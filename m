Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55575C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 20:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D17361606
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 20:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242487AbhCAUWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbhCAUTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 15:19:54 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6350C061793;
        Mon,  1 Mar 2021 12:18:54 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h9so3198465qtq.7;
        Mon, 01 Mar 2021 12:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=mp4k+nQSXGDqn7U9eUKU+r7sLycvnvmBWd3vV7uluwo=;
        b=W2kAbS8hMjvWSQ4Asyz+Z++V87f+DaeJ86vlPxkyLcNVk7irjVPlrpQKeCegI0vd6d
         On58BD2F7c1tpp/+zhfFDbun11yf0bjPP2VFIMQoiK9hfvco81cWQPIU/BJkbIdSZGmx
         c4NMaCaqmfoHVtxZxTnTRXI0GZP5Pc7x1xChfUtXPgQ2fNpYB0MdJGZWZYdj/WYP9yvJ
         rnvHIMoKZs0XJ1DROBjFPA7k71xTioQ6DLetESVIOztdE6MmmashkT8XllJZC+x5ZB9M
         5n71gpHFwTXYJd2qBNBE+jsVZ3Rr03CMF2zvRVroLPnEFSDk9e8+KgTemeaxI9xUcIEk
         ax2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=mp4k+nQSXGDqn7U9eUKU+r7sLycvnvmBWd3vV7uluwo=;
        b=RB+YHdgSj4Xy8xvGml3ImPJCWNGtModrn321OZoWsUkqHnnQ6hvC6ChRXgp/qTJ5lu
         qmXRmSIKCjVOs7ovkzGDCyVLSeiGlDy7NzoVZtCXSEsiuWxy1gDu9USrxftCd2rfRXrz
         OHxZaNG31MQCNTbhbgMdXW94Hn+gbk3zA61tI7gwWbLDqHrqILtcOkOcFWnAF8lcMXZV
         QWb1LDIUk93LtoXsoZS45rIVgZ2nDSDElNTPj0dCIC132HrS+mlCyckG61Y2YAIHDTu3
         teFo8i36e8JyoLlpOY9vAIze5VQy3nT3oYv1EtGtOYycZk4NlYn8W8LHZPUQ++BWD45N
         ymTg==
X-Gm-Message-State: AOAM530Lmn21J0kh1rxHcTNDPV8QC74Ltp/zI7xiXv50K21KbJVnxSlb
        fRy1CVGUwcF+hfT/jmVIMdw=
X-Google-Smtp-Source: ABdhPJywBgLoiEyTCbPcxuM3j/wBQ0aS2gCqQfdJye+9bs6IaI7bP4dn6anBRTHyqsW8V2lUAili/g==
X-Received: by 2002:ac8:6d3d:: with SMTP id r29mr14299839qtu.345.1614629934154;
        Mon, 01 Mar 2021 12:18:54 -0800 (PST)
Received: from Gentoo ([156.146.37.135])
        by smtp.gmail.com with ESMTPSA id i16sm13616399qkk.104.2021.03.01.12.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 12:18:53 -0800 (PST)
Date:   Tue, 2 Mar 2021 01:48:42 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: scsi: qla4xxx: Fix a spello in the file
 qla4xxx/ql4_os.c
Message-ID: <YD1MIiurUsyXUdQ2@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210301131736.14236-1-unixbhaskar@gmail.com>
 <e45931a9-b90e-8894-7081-61298c76abac@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+aJsZIf8/+7D6BkL"
Content-Disposition: inline
In-Reply-To: <e45931a9-b90e-8894-7081-61298c76abac@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--+aJsZIf8/+7D6BkL
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 08:56 Mon 01 Mar 2021, Randy Dunlap wrote:
>On 3/1/21 5:17 AM, Bhaskar Chowdhury wrote:
>>
>> s/circuting/circuiting/
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>
>Acked-by: Randy Dunlap <rdunlap@infradead.org>
>
>However:
>In lots of your patches, the subject begins with drivers:
>and we don't need that.  See the SCSI qla4xxx driver patches, e.g.:
>

Thanks, Randy....took note...about this ...will practice...


>$ git log --oneline drivers/scsi/qla4xxx/
>5b0ec4cf0494 scsi: qla4xxx: Use iscsi_is_session_online()
>35f1cad1f928 scsi: qla4xxx: Use standard SAM status definitions
>3a5b9fa2cc5f scsi: qla4xxx: Remove redundant assignment to variable rval
>014aced18aff scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_rom_lock()
>3627668c2e2c scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_idc_lock()
>a93c38353198 scsi: qla4xxx: Remove in_interrupt()
>cf4d4d8ebdb8 scsi: qla4xxx: Remove redundant assignment to variable rval
>5ccdd101351d scsi: qla4xxx: Fix inconsistent format argument type
>121432e87093 scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
>e3976af5a475 scsi/qla4xxx: Convert to SPDX license identifiers
>574918e69720 scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'
>d10d1df6301d scsi: qla4xxx: Rename function parameter descriptions
>6e3f4f68821b scsi: qla4xxx: Remove set but unused variable 'status'
>653557df36e0 scsi: qla4xxx: Supply description for 'code'
>f67e81641db7 scsi: qla4xxx: Remove three set but unused variables
>c0ad04b4b6d7 scsi: qla4xxx: Document qla4xxx_process_ddb()'s 'conn_err'
>fc5fba6e2ae2 scsi: qla4xxx: Repair function documentation headers
>cdeeb36d8f24 scsi: qla4xxx: Fix some kerneldoc parameter documentation issues
>67b8b93a559f scsi: qla4xxx: Fix incorrectly named function parameter
>0d5fea42989e scsi: qla4xxx: Fix-up incorrectly documented parameter
>
>> ---
>>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>> index a4b014e1cd8c..716a5827588c 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -6961,7 +6961,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
>>  	if (is_reset == RESET_ADAPTER) {
>>  		iscsi_block_session(cls_sess);
>>  		/* Use the relogin path to discover new devices
>> -		 *  by short-circuting the logic of setting
>> +		 *  by short-circuiting the logic of setting
>>  		 *  timer to relogin - instead set the flags
>>  		 *  to initiate login right away.
>>  		 */
>> --
>
>
>--
>~Randy
>

--+aJsZIf8/+7D6BkL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmA9TB8ACgkQsjqdtxFL
KRUHjAf/TO4QH3mHeXJuzf+KWFGtHw2RTlnGHaAQAMelPfRV6NanQidCdhgrgvHc
/SfMeL8KC8Bo7DBXYFTsFGHLQkay5H4r7Kks6h3hOC9N9hMs7j01dyjW/vn8de10
qFH5SULmHIORiAwCR046Oh/vr7AuNIkZIp8VYoo0909IthwaWq5PdnxVN9o2OTz3
QZDczSRkFOAavR1oe7Em8PXOHRmBUkDtYELXijZs5RZi8Yn8nvB66v95AcPAIp6w
ukbxqR3bIZO9FGJgLGZ2ZEBrS/UA0KR0fvbv5wPWRO3tBzO7KQJLawmN+ke24Ixf
hLUE0Dc2U8LNqLWyXDMrHqtdYh1DJA==
=U9YB
-----END PGP SIGNATURE-----

--+aJsZIf8/+7D6BkL--
