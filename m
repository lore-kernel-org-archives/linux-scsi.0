Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D1BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 04:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiDIEo1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Apr 2022 00:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiDIEo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2022 00:44:26 -0400
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BEC1D337
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 21:42:19 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 1AE04E0FCA;
        Sat,  9 Apr 2022 04:42:18 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 10A5E4BDEF;
        Sat,  9 Apr 2022 04:42:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id WXrZcF3KPm_L; Sat,  9 Apr 2022 04:42:17 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id EE33C4BDEE;
        Sat,  9 Apr 2022 04:42:16 +0000 (UTC)
Message-ID: <13393a17-b68d-c0b3-2baf-0b553265bc7d@interlog.com>
Date:   Sat, 9 Apr 2022 00:42:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/6] scsi_cmnd: reinstate support for cmd_len > 32
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        hch@lst.de
References: <20220408035651.6472-1-dgilbert@interlog.com>
 <20220408035651.6472-2-dgilbert@interlog.com>
 <78f9dc98-cca8-6ba2-9146-082f95c8d5ab@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <78f9dc98-cca8-6ba2-9146-082f95c8d5ab@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-04-08 10:55, Bart Van Assche wrote:
> On 4/7/22 20:56, Douglas Gilbert wrote:
>>   static int scsi_eh_tur(struct scsi_cmnd *scmd)
>>   {
>> -    static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
>> +    static const u8 tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
>>       int retry_cnt = 1;
>>       enum scsi_disposition rtn;
>>   retry_tur:
>> -    rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
>> -                scmd->device->eh_timeout, 0);
>> +    rtn = scsi_send_eh_cmnd(scmd, (u8 *)tur_command, 6, 
>> scmd->device->eh_timeout, 0);
> 
> Does the cast in the above function call cast away constness? There must be a 
> better solution than casting away constness.

The definition of scsi_send_eh_cmnd() is broken, obviously it doesn't
change the cdb of the passed argument. However I don't want to use
the const incorrectness of the existing code to avoid const in
the code I added. So retrofitting needs casts.

>> -bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
>> +bool scsi_cmd_allowed(/* const */ unsigned char *cmd, fmode_t mode)
>>   {
> 
> Why has 'const' been commented out?

Because I don't want to change that function's interface, just point out
how it is broken.

>> @@ -1460,6 +1462,7 @@ static void scsi_complete(struct request *rq)
>>   static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>>   {
>>       struct Scsi_Host *host = cmd->device->host;
>> +    u8 *cdb = (u8 *)scsi_cmnd_get_cdb(cmd);
>>       int rtn = 0;
> 
> Casting away constness is ugly. Consider providing two versions of 
> scsi_cmnd_get_cdb(): one version that accepts a const pointer and returns a 
> const pointer and another version that accepts a non-const pointer and returns a 
> non-const pointer. Maybe _Generic() or __same_type() can be used to combine both 
> versions into a single macro?

Yes, probably a scsi_cmnd_get_changeable_cdb() function which is safe as
long as the new cdb_len <= the existing cdb_len . I think it's the only
occasion I did that due to the cdb[1] overwrite in the lun_in_cdb case
(i.e. SCSI-2 SPI).

>> +/* This value is used to size a C array, see below if cdb length > 32 */
>> +#define SCSI_MAX_COMPILE_TIME_CDB_LEN 32
> 
> Since CDBs longer than 16 bytes are rare, how about using 16 as the maximum 
> compile-time CDB size?

Well that was the way it was before the surgery performed by Christoph.
If reducing the size of the scsi_cmnd structure by another 16 bytes
is that important, it can be easily done. My "long cdb" side of the
union takes 16 bytes currently (12 on a 32 bit machine).


IMO there should be comments added to scsi_cmnd.h to stress an object
of that type is always preceded (in memory) by a struct request object.
They are created as a pair, and are destroyed (freed, destructed) as
a pair.

Doug Gilbert
