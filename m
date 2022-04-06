Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E3EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 05:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbiDFFnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 01:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588082AbiDFFfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 01:35:43 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F3B35E2E8
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 18:06:17 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 7E4186184F
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:06:16 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 7592B62D23
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:06:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id 6JepFK7rWgXZ for <linux-scsi@vger.kernel.org>;
        Wed,  6 Apr 2022 01:06:16 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 0FD3D629DB
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:06:15 +0000 (UTC)
Message-ID: <43b9f7d7-658e-7452-c180-6a63b8e04cec@interlog.com>
Date:   Tue, 5 Apr 2022 21:06:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: scsi_cmnd.h partially consumes scsi_request.h
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
Content-Language: en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prior to lk 5.18.0-rc1 SCSI commands could be as long as the user wanted.
Practically they could not exceed 8+255 bytes due to the single byte
additional cdb length field in the variable length cdb format (opcode 7Fh).

Not any more. Now in include/scsi/scsi_cmnd.h we have the remnants of
include/scsi/scsi_request.h (deceased) and this questionable code:

.....
#define MAX_COMMAND_SIZE 16
.....

struct scsi_cmnd {
     ....
     unsigned char cmnd[32]; /* SCSI CDB <<<<<<< Ouch! */
     ....
};

So support for vendor specific cdb_s whose length is > 32 is gone. So is
support for any T10 cbd_s whose length is > 32 (mainly OSD). As is support
for XCDB_s (opcode 7Eh) which currently seems to be a placeholder for
future work by T10 (reference: spc6r06.pdf). XCDB_s are defined in SPC-5
(INCITS 502) which is the latest _standard_ .

And why the magic number "32", surely it deserves to be named?
And why keep the misleading MAX_COMMAND_SIZE define?


A suggestion ...

Change:
     unsigned char cmnd[32]; /* SCSI CDB */
to:
     union {
         u8 cmnd[MAX_COMPILE_TIME_CDB_LEN]; /* SCSI CDB */
         struct scsi_long_cdb l_cdb;
     };

And add a new scmd->flags value, a define, and that new struct prior
to the struct scsi_cmnd definition:
     #define SCMD_LONG_CDB               (1 << 3)

     #define MAX_COMPILE_TIME_CDB_LEN 32

     struct scsi_long_cdb {
         u64 dummy_tur;	  /* when zero yields Test Unit Ready cdb */
         u8 *cdbp;         /* byte length in scsi_cmnd::cmd_len */
     };


Plus the destructor for a scsi_cmnd object could free cdbp if the SCMD_LONG_CDB
flag is set. That will make life easier for "long_cdb" users.

Accessor functions:

/* Returns pointer to where cdb bytes can be written, or NULL if the allocation
  * associated with a "long" cdb fails. Copies in 'cdb' if it is non-NULL. If
  * cdb_len == 0 then function acts as a destructor and returns NULL. */
     u8 * scsi_cmnd_set_cdb(struct scsi_cmnd *scmd, u8 * cdb, u16 cdb_len)
     {
         if (unlikely(scmd->flags & SCMD_LONG_CDB)) {
             if (cdb_len > MAX_COMPILE_TIME_CDB_LEN &&
                 cdb_len <= scmd->cmd_len) {
                 if (cdb)
                     memcpy(scmd->l_cdb.cdbp, cdb, cdb_len);
                 scmd->cmd_len = cdb_len;
                 return scmd->l_cdb.cdbp;
             kfree(scmd->l_cdb.cdbp);
             scmd->l_cdb.cdbp = NULL;
             scmd->flags &= ~SCMD_LONG_CDB;
         }
         scmd->cmd_len = cdb_len;
         if (cdb_len == 0)
             return NULL;
         if (likely(cdb_len <= MAX_COMPILE_TIME_CDB_LEN)) {
             if (cdb)
                 memcpy(scmd->cmnd, cdb, cdb_len);
             return scmd->cmnd;
         }
         scmd->l_cdb.cdbp = kzalloc(cdb_len, GFP_KERNEL);
         if (!scmd->l_cdb.cdbp) {
             scmd->cmd_len = 0;
             return NULL;
         }
         scmd->flags |= SCMD_LONG_CDB;
         scmd->l_cdb.dummy_tur = 0;  /* defensive: cheap aid when testing */
         if (cdb)
             memcpy(scmd->l_cdb.cdbp, cdb, cdb_len);
         return scmd->l_cdb.cdbp;
     }

/* Associated cdb length is in scmd->cmd_len . Should not be used for
  * modifying a cdb (hence the const_s). */
     const u8 * scsi_cmnd_get_cdb(const struct scsi_cmnd *scmd)
     {
         return (scmd->flags & SCMD_LONG_CDB) ? scmd->l_cdb.cdbp :
                                                scmd->cmnd;
     }

The latter can be inlined.

LLDs can ignore the above if they do not support > 32 bytes in their cdb_s.
Otherwise they can call the 'get' accessor function above.

Notice sizeof(struct scsi_cmnd) is not changed by this suggestion. One extra
bit is used in scmd->flags .


Doug Gilbert
