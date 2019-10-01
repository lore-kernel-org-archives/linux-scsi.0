Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030D4C32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F9620842
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CnWJSO7i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CSN3U2oF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfJACJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:09:52 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34666 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfJACJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 22:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569895790; x=1601431790;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=29Njri/AmSaDRn4EnJjttB0InZJyTKe4u1sMXpk3Yqc=;
  b=CnWJSO7ilnsMFxdLy0GgzhGLCbpMCnHK0xnGEiQ6WyToZ20/bzdzjr5t
   RKS83rh/nJbFuAaQrKYeGsf6vHprYl475g6ej4izEfkNg9uJTMbF7rwq5
   yr9ZZP5jbHkkD0XYYQLugPV43mBYA1ZLZDcqinjmD3xUJHjMTkw18K0O3
   iPpLKnN73I34w5zf7ONdCa0M9D3PtkTWMNNlZhp/HOBc8+KmIM6Tr82C2
   kooGh4wf+jnq/iKF7B58OMEd0CJQ/GpE8MROwA8Q6+oiYr7jVJ9dDzdZ8
   IeUC0B/CH/+uuAANAjSAwmOMuXs6q9OS+fyMhezEZMYnsg/KV2r8+J0Kb
   Q==;
IronPort-SDR: aHMxlB1lBiVmaLKxCxphi8HjV5obV4QAHYMtJR0pXbdpR7zZVW0n9jLa1ITS4Kf2hNEfYt7lNO
 2eVGtETat5uLCAA0yiZclX1VwM+Hf81w+6R4b2wJZWI3Fwvz/NUa8djHXok3MLiaQZMuEK0Vtq
 3Cn/247A6cfEzM/nyogj8mXJszvAafBlNctvVV7PCszOm6TlUwGGRzVY7d6YMJQtpl6F8SlvdB
 fk3WkMnXGr2w1A5jWuyC3Gcs8L3rtuIOslgCXR0tKy3KVLtVxsScUTt94sfzycUkihlqakICVZ
 /eQ=
X-IronPort-AV: E=Sophos;i="5.64,569,1559491200"; 
   d="scan'208";a="119490019"
Received: from mail-sn1nam04lp2056.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.56])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2019 10:09:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIabU/iG/3VLv44gXth+6ABGnpRaJX2iC2qHHJ0j6XzRuSNBTF2KuX/Tp4W2WtXWL89h4IeHU/TLmh9LfdQgI7pBCgt3oTEXfI2JOiRF7N/upgDODSNKFdTi51daVki2UGZaaRdEjLKd1ZAjvcsqA77b4yBdqJJkCyjogfp/r+3ir+4ZstsC65i1Gh2+nD7GAXa4/2RaHHCOo1AVYAqihDHZzleGVhAK3p8RtuXSlBFMiSGwahIPUQ2pcW7TgN+8V0NRPHJP+he4C0ml7Vf/S07u7YGW/ZqwWcOwK2bXmpJrtUOhgx44j4iiMrqU+gSL63OSnYeZE3xcvn93ndYmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRhuZcN1E/O4xAIEIK5Lr6AVcdJOpZNP3j+CspGWVo0=;
 b=e/9BPpDUsw4lRIGHMRDLOwT6iZ8n3OFCfZog+IE+otAIiWow4iMsn5um5kvZzH4Ba5dutfE1j1iboEhhybBvM2fkIqvKHnaZBVfDcfiBBHqbd3Y2EYwbf1WfVRXAJksnU91qR5x6kgH47RCMxETu4ZKT6vLO8aR86FaDpaC4puy7xEYRgxuAuuQmR58orY8W+vvMAmUwG7Er6qsz8MkPi354CqgqXIjaOHqXJLVUyeAt+pmy7fTwS++Hqvvff/rJfNvYeyUga0aJW+14reOedk7p65cW/YbABIKaW2SqNYHSbpXhYv4Btgadi0EjP6JzoDW7y1+pdaIqIP1kRblLeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRhuZcN1E/O4xAIEIK5Lr6AVcdJOpZNP3j+CspGWVo0=;
 b=CSN3U2oFG455jM9bRh5N4Vehc9jCb0BMnsAFtcxq+zTvNaxgIR+Rq6ZvMCXgC85Yf4jTcXX8Rgly8uVLqpZlj6FrgChtrRx1qkqaQ/7PZE5kQN+LkRE1DYBtCYLzkXalmprXD2L6MRcKwl5MtLHAdOSn0H+VawVTqRECUT1Ow3Y=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5480.namprd04.prod.outlook.com (20.178.197.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Tue, 1 Oct 2019 02:09:43 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::84c4:833e:ec0b:5053]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::84c4:833e:ec0b:5053%2]) with mapi id 15.20.2305.017; Tue, 1 Oct 2019
 02:09:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH V2] scsi: save/restore command resid for error handling
Thread-Topic: [PATCH V2] scsi: save/restore command resid for error handling
Thread-Index: AQHVdYErv4G7y50U7UCkETxGlX0DaQ==
Date:   Tue, 1 Oct 2019 02:09:43 +0000
Message-ID: <BYAPR04MB5816FBEE392BE5E4BCF14B96E79D0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190927221602.27080-1-damien.lemoal@wdc.com>
 <alpine.LNX.2.21.1910011011410.13@nippy.intranet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [83.175.114.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89ec00cc-df26-4eca-1140-08d746146cff
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB5480:
x-microsoft-antispam-prvs: <BYAPR04MB548055E69FBD4356C93C752BE79D0@BYAPR04MB5480.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(189003)(199004)(54906003)(7696005)(102836004)(6436002)(9686003)(229853002)(86362001)(25786009)(66066001)(6116002)(2906002)(3846002)(186003)(6916009)(55016002)(6246003)(76176011)(53546011)(6506007)(478600001)(26005)(4326008)(5660300002)(8936002)(8676002)(14454004)(81156014)(81166006)(52536014)(99286004)(7736002)(316002)(91956017)(446003)(14444005)(305945005)(71200400001)(74316002)(76116006)(71190400001)(66946007)(64756008)(66476007)(66446008)(256004)(66556008)(33656002)(486006)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5480;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CcvJ1ZHkptQtlPtwAeyoR+LvefESzrBxnRXfs3cRrw/K+jQrqgSkQq0wO7UHwrGxUsT2Z5ZhbJ4bXwM6PJQP/EFXAHjYEqQQ03y53sp4nX+b0Vmu7EgHFPY1dB5CGl9HUsxrs7+LmpGVH5sVB9CCVVvLUz2KjrtnClebKTaPwrwWOGrcIiAZx/XwpSsOCJrhGUKXX4YN2G5JzEHlsna+spcPVS3kFziyzJPmO4Z3lPHaHI2A7QMk59/wH9jL1AHR9c6OuZ4lE1UtKpRMGR7V6ib+YUSGeWeL6dDTUrOTzgopvB121bC1uxmWIjsTK66N8+PxZ4TQVpwgVhwXDt/Ndv1oXWvxp1nfqHNCiAIsagMVFPlON5LZqLJaPZM73DCuvmI7kn1wmXWA/LOqL5ct4wxTw6jCs8kOf2Nz9q1ZlXw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ec00cc-df26-4eca-1140-08d746146cff
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 02:09:43.5951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x2tVsj6sz4xpx+7dzOJWENzp/qpG+s4r3OuK356QH0BqgqeBRxHiTifHXV3DNd8OYwUFA6iVZuLSUwWrSouwSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5480
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/30 17:42, Finn Thain wrote:=0A=
> On Sat, 28 Sep 2019, Damien Le Moal wrote:=0A=
> =0A=
>> When a non-passthrough command is terminated with CHECK CONDITION,=0A=
>> request sense is executed by hijacking the command descriptor. Since=0A=
>> scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() do not save/restore the=
=0A=
>> original command resid, the value returned on failure of the original=0A=
>> command is lost and replaced with the value set by the execution of the=
=0A=
>> request sense command. This value may in many instances be unaligned to=
=0A=
>> the device sector size, causing sd_done() to print a warning message=0A=
>> about the incorrect unaligned resid before the command is retried or=0A=
>> aborted.=0A=
>>=0A=
>> Fix this problem by saving the original command resid in struct=0A=
>> scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in=0A=
>> scsi_eh_restore_cmnd(). In addition, to make sure that the request sense=
=0A=
>> command is executed with a correctly initialized command structure, also=
=0A=
>> reset resid to 0 in scsi_eh_prep_cmnd() after saving the original=0A=
>> command resid value in struct scsi_eh_save.=0A=
>>=0A=
>> Cc: stable@vger.kernel.org=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>=0A=
>> Changes from V1:=0A=
>> * Dropped patch 2=0A=
>> * Add resid reset in scsi_eh_prep_cmnd()=0A=
>>=0A=
>>  drivers/scsi/scsi_error.c | 3 +++=0A=
>>  include/scsi/scsi_eh.h    | 1 +=0A=
>>  2 files changed, 4 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c=0A=
>> index 1c470e31ae81..f53828bf7ad7 100644=0A=
>> --- a/drivers/scsi/scsi_error.c=0A=
>> +++ b/drivers/scsi/scsi_error.c=0A=
>> @@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struc=
t scsi_eh_save *ses,=0A=
>>  	ses->data_direction =3D scmd->sc_data_direction;=0A=
>>  	ses->sdb =3D scmd->sdb;=0A=
>>  	ses->result =3D scmd->result;=0A=
>> +	ses->resid =3D scsi_get_resid(scmd);=0A=
>>  	ses->underflow =3D scmd->underflow;=0A=
>>  	ses->prot_op =3D scmd->prot_op;=0A=
>>  	ses->eh_eflags =3D scmd->eh_eflags;=0A=
>> @@ -977,6 +978,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struc=
t scsi_eh_save *ses,=0A=
>>  	memset(scmd->cmnd, 0, BLK_MAX_CDB);=0A=
>>  	memset(&scmd->sdb, 0, sizeof(scmd->sdb));=0A=
>>  	scmd->result =3D 0;=0A=
>> +	scsi_set_resid(scmd, 0);=0A=
>>  =0A=
>>  	if (sense_bytes) {=0A=
>>  		scmd->sdb.length =3D min_t(unsigned, SCSI_SENSE_BUFFERSIZE,=0A=
>> @@ -1029,6 +1031,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, =
struct scsi_eh_save *ses)=0A=
>>  	scmd->sc_data_direction =3D ses->data_direction;=0A=
>>  	scmd->sdb =3D ses->sdb;=0A=
>>  	scmd->result =3D ses->result;=0A=
>> +	scsi_set_resid(scmd, ses->resid);=0A=
> =0A=
> When saving and restoring state, perhaps it makes more sense to bypass th=
e =0A=
> higher level getter/setter API? Open-coded assignment statements are =0A=
> already prevalent here, rather than calls to e.g. scsi_set_prot_op(), =0A=
> set_msg_byte() etc. (There may be no code elsewhere that could tell the =
=0A=
> difference, but we can't use "private" members to prove it, unlike C++.)=
=0A=
> =0A=
>>  	scmd->underflow =3D ses->underflow;=0A=
>>  	scmd->prot_op =3D ses->prot_op;=0A=
>>  	scmd->eh_eflags =3D ses->eh_eflags;=0A=
>> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h=0A=
>> index 3810b340551c..9caa9b262a32 100644=0A=
>> --- a/include/scsi/scsi_eh.h=0A=
>> +++ b/include/scsi/scsi_eh.h=0A=
>> @@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int =
__user *);=0A=
>>  struct scsi_eh_save {=0A=
>>  	/* saved state */=0A=
>>  	int result;=0A=
>> +	unsigned int resid;=0A=
> =0A=
> There seems to be an inconsistency here. A signed int would be consistent=
 =0A=
> with the getter and setter helpers. Whereas, if you open-coded the =0A=
> assignments instead, your unsigned int would make sense because =0A=
> scsi_request.resid_len really is an unsigned int.=0A=
=0A=
All fair points. Sending a V3. Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
