Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DA6C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB1CF61A01
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhCYCda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:33:30 -0400
Received: from gateway34.websitewelcome.com ([192.185.149.77]:11628 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236075AbhCYCd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 22:33:29 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 22:33:29 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id E149AA2DA7C8
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 20:46:44 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id PF5AlLhVTw11MPF5AlCHsY; Wed, 24 Mar 2021 20:46:44 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ARp6l6XyGFRCRrhLJmTKi/VHzAiBKs0aN+5y9cJbGsU=; b=p7AUZuJrSLjG9Izr8yGa03cQAF
        6Stx9tQGXORllkuk2Ynh1tIujjdsjjmPyTJ9bnKLb+Hg+RkKzBCqzBxQqzkjjoN8fLFFv90rknxBI
        MgM9AyV3zlbdo0H/M2EqDMGwok+TOrd1rQ8+6sk2OUC4/Ps/54EnRhHmTenAPhYuX45z1zsWGxmkM
        gH3mDjo/ppnEgqZqFoaSN3vFUU1FEDln+zwNhq4ug9tieFjWhxbJBpiVUoYwwLJvzzjqgoqahY99x
        j43vrlFWltJXvnPRPtTj34z1MyLv6iaMUHrvJYEPjFwxcJwl9eFKRGpa9ytzxcKILh+4pqbDbo42j
        z3LtzqKg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38484 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lPF59-003rfr-NW; Wed, 24 Mar 2021 20:46:43 -0500
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210304203822.GA102218@embeddedor>
 <yq135wkm410.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <668e3f30-1ffb-31e3-231b-705489993885@embeddedor.com>
Date:   Wed, 24 Mar 2021 19:46:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <yq135wkm410.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lPF59-003rfr-NW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:38484
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 3/24/21 20:18, Martin K. Petersen wrote:
> 
> Hi Gustavo!
> 
> Your changes and the original code do not appear to be functionally
> equivalent.
> 
>> @@ -1235,8 +1235,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>>  		if (ret < 0)
>>  			return ret;
>>  		command = ContainerRawIo2;
>> -		fibsize = sizeof(struct aac_raw_io2) +
>> -			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
>> +		fibsize = struct_size(readcmd2, sge,
>> +				     le32_to_cpu(readcmd2->sgeCnt));
> 
> The old code allocated sgeCnt-1 elements (whether that was a mistake or
> not I do not know) whereas the new code would send a larger fib to the
> ASIC. I don't have any aacraid adapters and I am hesitant to merging
> changes that have not been validated on real hardware.

Precisely this sort of confusion is one of the things we want to avoid
by using flexible-array members instead of one-element arrays.

fibsize is actually the same for both the old and the new code. The
difference is that in the original code, the one-element array _sge_
at the bottom of struct aac_raw_io2, contributes to the size of the
structure, as it occupies at least as much space as a single object
of its type. On the other hand, flexible-array members don't contribute
to the size of the enclosing structure. See below...

Old code:

$ pahole -C aac_raw_io2 drivers/scsi/aacraid/aachba.o
struct aac_raw_io2 {
	__le32                     blockLow;             /*     0     4 */
	__le32                     blockHigh;            /*     4     4 */
	__le32                     byteCount;            /*     8     4 */
	__le16                     cid;                  /*    12     2 */
	__le16                     flags;                /*    14     2 */
	__le32                     sgeFirstSize;         /*    16     4 */
	__le32                     sgeNominalSize;       /*    20     4 */
	u8                         sgeCnt;               /*    24     1 */
	u8                         bpTotal;              /*    25     1 */
	u8                         bpComplete;           /*    26     1 */
	u8                         sgeFirstIndex;        /*    27     1 */
	u8                         unused[4];            /*    28     4 */
	struct sge_ieee1212        sge[1];               /*    32    16 */

	/* size: 48, cachelines: 1, members: 13 */
	/* last cacheline: 48 bytes */
};

New code:

$ pahole -C aac_raw_io2 drivers/scsi/aacraid/aachba.o
struct aac_raw_io2 {
	__le32                     blockLow;             /*     0     4 */
	__le32                     blockHigh;            /*     4     4 */
	__le32                     byteCount;            /*     8     4 */
	__le16                     cid;                  /*    12     2 */
	__le16                     flags;                /*    14     2 */
	__le32                     sgeFirstSize;         /*    16     4 */
	__le32                     sgeNominalSize;       /*    20     4 */
	u8                         sgeCnt;               /*    24     1 */
	u8                         bpTotal;              /*    25     1 */
	u8                         bpComplete;           /*    26     1 */
	u8                         sgeFirstIndex;        /*    27     1 */
	u8                         unused[4];            /*    28     4 */
	struct sge_ieee1212        sge[];                /*    32     0 */

	/* size: 32, cachelines: 1, members: 13 */
	/* last cacheline: 32 bytes */
};

So, the old code allocates sgeCnt-1 elements because sizeof(struct aac_raw_io2) is
already counting one element of the _sge_ array.

Please, let me know if this is clear now.

Thanks!
--
Gustavo
