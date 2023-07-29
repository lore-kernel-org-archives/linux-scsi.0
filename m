Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7DDC001DC
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Jul 2023 08:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjG2IfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Jul 2023 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjG2IfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jul 2023 04:35:19 -0400
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EB8448C
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2023 01:35:17 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690619716; x=1690626916; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Subject: Cc: To: To: From: From: Date:
 Sender: Sender; bh=y3sLkviRUL6QYQRMqhy3slBrjN+BHnnZlmEhHkBFmXo=;
 b=oJtnqnkh3JOWbEOqRjTejNFcAn7RsxKV/hKUTiZSoOzXIwabuIc88XUTCmw2MR4HFlwBwGv0fM0w9wxYhmf33JFLU5sk/RsM0QyES2+YKIdsJ4jci9NpsSm+Ei+hhS845PozGiBaU5Kg2f7X4cUGxlexyKcW9+y9fPZ+fbKuA/dUBvVD3sM7C/sRp5NG+KyxJB8diOdc9Jp9e3h5oH4oyxGqAdRQNlr1YlFj9n/aG38hHYsLvO3PUxMzQZEZpmD7PYfKJaz05haPji/W11JhusgXsgHVi+RO9kP8cjV2BR5GIwIAKd8260bgSCXtYNgeueBnjM8F/ymo1KpU5LfWAQ==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 0d28b296750d with SMTP id
 64c4cf44ba84a2456296a7cc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 29 Jul 2023 08:35:16 GMT
Sender: james@equiv.tech
Date:   Sat, 29 Jul 2023 01:35:15 -0700
From:   James Seo <james@equiv.tech>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] scsi: mpt3sas: Replace a dynamic allocation with a
 local variable
Message-ID: <ZMTPQ9c0hmVBapxe@equiv.tech>
References: <20230725161331.27481-1-james@equiv.tech>
 <20230725161331.27481-7-james@equiv.tech>
 <202307281528.086CF1D063@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202307281528.086CF1D063@keescook>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 28, 2023 at 03:29:17PM -0700, Kees Cook wrote:
> On Tue, Jul 25, 2023 at 09:13:31AM -0700, James Seo wrote:
>> This dynamic allocation can be replaced with a local variable.
>> 
>> Signed-off-by: James Seo <james@equiv.tech>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 19 +++++--------------
>>  1 file changed, 5 insertions(+), 14 deletions(-)
>> 
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index cd6f36094159..a32a6fa728a7 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -5361,10 +5361,9 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
>>  static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
>>  {
>>  	Mpi2ConfigReply_t mpi_reply;
>> -	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
>> +	Mpi2SasIOUnitPage1_t sas_iounit_pg1;
>>  	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
>>  	u16 depth;
>> -	int sz;
>>  	int rc = 0;
>>  
>>  	ioc->max_wideport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
>> @@ -5374,28 +5373,21 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
>>  	if (!ioc->is_gen35_ioc)
>>  		goto out;
>>  	/* sas iounit page 1 */
>> -	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
>> -	sas_iounit_pg1 = kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
> 
> Hunh. So Mpi2SasIOUnitPage1_t is used without the flexarray at all?
> 
> -Kees

You call it "dead code" and "unused struct members".
mpt3sas evidently calls it "documentation" ;)

Anyway, does this commit get your "Reviewed-by:"?

James

