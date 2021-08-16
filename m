Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1635EC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F129B60F11
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhHPSRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 14:17:24 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39648 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229881AbhHPSRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 14:17:24 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0D1A24AB80;
        Mon, 16 Aug 2021 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1629137806; x=
        1630952207; bh=VIa6IrsRyv7o0CFloydxw+2OANf7ocVc0lxmNW3Dons=; b=W
        AIhk+M0eNkDJhaF0V3/+TJK+uN8r5J/hbLfY4Si6CYRNKIUe83gX+zTe0YPqxfpK
        iklqxPMClmBHum8U0UAztXBhFpVXs2wyXn4KPVn1II+aR35OVfwkeSbJzo4eU9Vt
        WWGuZMSVJ+hB7TZHnEjkR5aTDHQJ6mQ6QiFfSYsPQc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s8VfFSBqbaGW; Mon, 16 Aug 2021 21:16:46 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3BE024AAFF;
        Mon, 16 Aug 2021 21:16:46 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 16 Aug 2021 21:16:45 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 16 Aug 2021 21:16:45 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     David Disseldorp <ddiss@suse.de>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        "Konstantin Shelekhin" <k.shelekhin@yadro.com>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: RE: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Thread-Topic: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Thread-Index: AQHXhLcssCQJNB+MhEaxc5KsP0wx/KtxahKAgAUcf/A=
Date:   Mon, 16 Aug 2021 18:16:45 +0000
Message-ID: <741b4c6f78484591a57cbdb3bd64c924@yadro.com>
References: <20210729201943.40222-1-s.samoylenko@yadro.com>
        <20210729201943.40222-2-s.samoylenko@yadro.com>
 <20210813165255.650257ce@suse.de>
In-Reply-To: <20210813165255.650257ce@suse.de>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi David,

> Hi Sergey,
>
> On Thu, 29 Jul 2021 23:19:43 +0300, Sergey Samoylenko wrote:
>
>> The 8Fh VPD page announces the capabilities supported by
>> the TCM XCOPY manager. It helps to expand the coverage of
>> the third-party copy manager with SCSI testing utilities.
>
> Please list which initiators use this VPD page, if you know of any.
I know that the ESXi 7.0 requests the 8Fh VPD page. ESXi is one of
a few initiators who is using the XCOPY commands (vmkfstools tool).

> Also, is there any test coverage for this? I don't see anything in
> libiscsi...
After activating XCOPY in a target we got an error from
the SCSI.ReceiveCopyResults.CopyStatus test in the libiscsi.
Discussing with Bart, we decided to implement the 8Fh VPD page
for announcing TCM XCOPY features.
It is here: https://github.com/sahlberg/libiscsi/pull/353

The libiscsi has an initial version for parsing 8Fh VPD. This is used
in the SCSI.ReceiveCopyResults.CopyStatus test. It is a good idea
to add test coverage for 8Fh VPD in libiscsi. I should do this.

>
>> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>> Reviewed-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
>> Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
>> ---
>>  drivers/target/target_core_spc.c | 230 ++++++++++++++++++++++++++++++-
>>  1 file changed, 226 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_co=
re_spc.c
>> index 22703a0dbd07..169341712b10 100644
>> --- a/drivers/target/target_core_spc.c
>> +++ b/drivers/target/target_core_spc.c
> ...
>> +/* Third-party Copy VPD page */
>> +static sense_reason_t
>> +spc_emulate_evpd_8f(struct se_cmd *cmd, unsigned char *buf)
>> +{
>> +	struct se_device *dev =3D cmd->se_dev;
>> +	int off;
>> +	u16 page_len;
>> +
>> +	if (!dev->dev_attrib.emulate_3pc)
>> +		return TCM_INVALID_CDB_FIELD;
>> +
>> +	/*
>> +	 * Since the Third-party copy manager in TCM is quite simple
>> +	 * and supports only two commands, the function sets
>> +	 * many descriptor parameters as constants.
>> +	 *
>> +	 * As the Copy manager supports the EXTENDED COPY(LID1) command,
>> +	 * the Third-party Copy VPD page should include five mandatory
>> +	 * Third-party copy descriptors. Its are:
>> +	 *   0001h - Supported Commands
>> +	 *   0004h - Parameter Data
>> +	 *   0008h - Supported Descriptors
>> +	 *   000Ch - Supported CSCD Descriptor IDs
>> +	 *   8001h - General Copy Operations
>> +	 *
>> +	 * See spc4 section 7.8.17
>> +	 */
>> +
>> +	off =3D 4;
>> +
>> +	/* fill descriptors */
>> +	off +=3D spc_evpd_8f_encode_supp_cmds(&buf[off]);
>> +	off +=3D spc_evpd_8f_encode_param_data(&buf[off]);
>> +	off +=3D spc_evpd_8f_encode_supp_descrs(&buf[off]);
>> +	off +=3D spc_evpd_8f_encode_supp_cscd_descr_id(&buf[off]);
>> +	off +=3D spc_evpd_8f_encode_general_copy_ops(&buf[off]);
>
> This looks risky in terms of buf overrun. I think it'd be good to pass
> a @remaining or @buf_end param to these helper functions.

I thought about it, but spc_emulate_evpd_XX functions have a prototype:
	sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *);
and they don't know anything about buffer length. I can use the
"SE_INQUIRY_BUF" definition, but I don't like this solution.
=09
We can change the prototype of spc_emulate_evpd_XX functions, like:
	static struct {
		uint8_t page;
		sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *buf, size_t len=
);
	} evpd_handlers[] =3D {
		...
	};
and return the TCM_OUT_OF_RESOURCES if we try to overrun buffer
in spc_emulate_evpd_XX. But this will require changing all "emulate_evpd" f=
unctions.

David, what do you think of this?

>
> Cheers, David

Best regards, Sergey

