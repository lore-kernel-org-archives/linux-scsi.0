Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB4CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D745820700
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="nmhMB1xw";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="UBKTM13Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgFYX7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:59:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbgFYX7d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 19:59:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PNvPp3010932;
        Thu, 25 Jun 2020 16:59:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=8YL98FMamLJ/Uo9Stp0wGEZoFjd2wthfsqK6sl7OQyk=;
 b=nmhMB1xwMRKls4QsPKsjvuzUeYOGPjOSofeL8TRSHro1b4L53nWKyXGw2FABaDUO2znW
 sRgHQwNi0gxGu8jzxBIs1MLlUoF8gm/Wom5uTJElpQ6lop10lh0t5ftz3vpbweNouym5
 3i1+31q43Mqfo1qsVlfI2JnfJOOD3gBtMmHq0M7lVZ6JNNf206bN8g8vK67U9eFdj93f
 UM/bcVmRvCQQ6LWAJSBbytHZLkz2HrU+/o+kVd8THGzAzRgr0gFtVb+kMaZttpomWoru
 zrnWBnykZ/KQImo+7YoXxNf4YGTMQ8eVV7U0maM9ZyRKZWBRntFPQ+prLLe/IqlcIdcX 6w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31uur1hyyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 16:59:28 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 16:59:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 16:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CANgoofNJ7lK3ZnpYL17cHhPU8bIIcHt3AQ3sDneZvoPgYMPuXRXH0wBkPqMQp4EoHNoywqsciHioJDwS1SgOcYVoMe27uJ7KDSlu4yMHtnP7RoPRoiG3QuH1cOxOTJ0E6UIpBeZ6RyVAsbWn6iXAkhQsjcIClLh/59HrSGLUVfPAHBU5pnofHGovCWhwsKqvNCNHsFntsT7ya/noSvA4FcHhahAYGcjWQheqQQepdkrc84fWjoZJPIvNLDHND6n6poC0EsjmfQ2HLB5AzYxhzaaWCTgzcwa4oYKqtlugSOuIb38j9jmJNUU00RVoHshh+NyZXUe1adV+nCZAxQTqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YL98FMamLJ/Uo9Stp0wGEZoFjd2wthfsqK6sl7OQyk=;
 b=GxqqHVX3x9ids7buRlAsM9JziLw42ifrBbAt2scDaT8udTXkwUBWYwvJLPC2U0oGGRgLRiwIsk6hxz+5npmHprp+TOs6KFnlK6zg6lbW9S/aGOq+yF5UlKS75WdtAq2voTqUBH0Pxxrh3jabRNNwQKTxKWvAxPG5dsV6RonsRjPZD2d6a5r70yasUmK/yqCx+y6PS7KOETNWUnKaEBFD0Tqz3Sw9U/KQVfuJ1ytZDl23o8GWJrNBx8gYqiBzq2Lgig4pjcrTki7I6dKEI9rELBskoWdT5Bj14kZ95CuK7HHaKgAgxJJd5drUhDoHitXg46XK6OFx95GOVRB5O+mTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YL98FMamLJ/Uo9Stp0wGEZoFjd2wthfsqK6sl7OQyk=;
 b=UBKTM13YODWQ73ekv70tcar2/uH1tiVZvUcJ+oD3zEEmoeL/3XcPKUT5iW7ZQAzS36FAGtzd8+2Z5C1fQbcWOyNNCUnYVSDCeVzWZpaVNYxlTg3iwyvAV3QYv1wV1z9Sm+X5tYvBDlQUS/jVLIktwWflkxf7Nn1nCU6cwK0Ww4s=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2885.namprd18.prod.outlook.com (2603:10b6:a03:10e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 25 Jun
 2020 23:59:25 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3131.024; Thu, 25 Jun 2020
 23:59:25 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     James Smart <james.smart@broadcom.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3 1/2] qla2xxx: Change in PUREX to handle FPIN ELS
 requests.
Thread-Topic: [PATCH v3 1/2] qla2xxx: Change in PUREX to handle FPIN ELS
 requests.
Thread-Index: AQHWPzGygAiCffjpsEOm6HAht6OCz6jqFRwAgAAFzQA=
Date:   Thu, 25 Jun 2020 23:59:24 +0000
Message-ID: <C21EFEF3-1BDB-4B2E-93B9-CE27D6816C95@marvell.com>
References: <20200610141509.10616-1-njavali@marvell.com>
 <20200610141509.10616-2-njavali@marvell.com>
 <5910af97-d0a2-a77a-627b-c80c73371fd6@broadcom.com>
In-Reply-To: <5910af97-d0a2-a77a-627b-c80c73371fd6@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:a138:68ec:c97d:2206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c1978cb-53d0-4aab-184c-08d81963c9ef
x-ms-traffictypediagnostic: BYAPR18MB2885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2885259A3F04E5EE998D108FB4920@BYAPR18MB2885.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SwQwuwkDV+wD8EODsIQ/Knfg2VvPZ3k10QleD761c5Fp9CiFqvt8bdLlQHpKPrr9wx6sXUvYIJPL5pSU6F4o5CBUe2ayeyJGne8+Z0MtS08zmyPq6c01D8ZsIfOsVTo0yZvRdKOmHND2fvcCuVJXYv60PIO+g5PUtpVwc+dBAcLRik/+N/g+mL81NUBoHgRf13vBAvXjTS4BBhgLN14TjnHVXkeGhOwuMJX2XZxm8wwzgFHOkFjT2KToolgP6NsOyF+bClZAzCeXmP+UL+xoGMl3dsrIKxnLbh29SdJl/ADowRCb9TJQe9OsygJ8KfVbqsUW8YABrOfVEF0295hkEm27hRDtNhFQ3w9GJaQZT3kBvL73mPjbbvUS+Stj3dSn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(136003)(346002)(376002)(366004)(316002)(71200400001)(30864003)(186003)(83380400001)(33656002)(66946007)(76116006)(66476007)(8676002)(5660300002)(8936002)(66446008)(66556008)(6486002)(6916009)(64756008)(36756003)(66574015)(6512007)(54906003)(478600001)(107886003)(86362001)(53546011)(6506007)(2616005)(2906002)(4326008)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Z4OAJAQl47S471vur52U1r8fe6CZuUyqfU7h9+CaxlBRq/rygD3yDu+kpTE27zXca68UJ0G4bkWDt8yQpVE5Z/fAyThZpkJz6TyvBJjphoNeDgEeAkSpVED3NR2hNMu8l9JeK4s+ILW7C00u5GlUqKjoA7QJSUILwLtTrYFe1iFr/HAPV0dP5GX+yQRPKC1sS5Afvsh9gSyg4jjWxyVt7Gv4Rkem2u/uZuS80tuv3C+OTfElEfxjHVa5c7nzs9oPrtBweU8rbs0HnBh+Q4vxCI7abIbzNNNfj+VtZbYkyI8NVrSA5pxHQy6sZx9WUbuxK/+omhOfi/Jvv5EkD4j6r03EmGeL+rnzumbu7752PuH96vHiNS3KRfi59X2PJjMjAov0kEIrkaeeZFUzWbs+nacwg6kXkMswWoryWA5/6wUDNRuTzsxWG1lX/G/r6B4BlWUw0NNlyXjYlyQ4l3Q+XrMcrRF6zpyILorEBHbjtjK+C4FYYa/copOmTUg+UPLZzM+/lXQgUOGeta2v6kJmjesu7O+UUriXsKTOMuS3aaEEZHRiGxREsW+LYoQoph8G
Content-Type: text/plain; charset="us-ascii"
Content-ID: <805A31E66E757B46B0CAFE7D8E325762@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1978cb-53d0-4aab-184c-08d81963c9ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 23:59:25.0043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQRmHnqlSXpMYvvoytiNcVshIHlxXWceZqYlu1SqxGJLtK879Ojq9FDCAxNxDY7pqlVmSGhq0ZCqXoendDU9Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2885
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for the review James, response inline.

> On Jun 25, 2020, at 4:38 PM, James Smart <james.smart@broadcom.com> wrote=
:
>=20
>=20
>=20
> On 6/10/2020 7:15 AM, Nilesh Javali wrote:
>> From: Shyam Sundar <ssundar@marvell.com>
>>=20
>> SAN Congestion Management generates ELS pkts whose size
>> can vary, and be > 64 bytes. Change the purex
>> handling code to support non standard ELS pkt size.
>>=20
>> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
>> Signed-off-by: Arun Easi <aeasi@marvell.com>
>> Signed-off-by: Nilesh Javali <njavali@marvell.com>
>> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_def.h |  20 +++++-
>>  drivers/scsi/qla2xxx/qla_gbl.h |   3 +-
>>  drivers/scsi/qla2xxx/qla_isr.c | 116 ++++++++++++++++++++++++---------
>>  drivers/scsi/qla2xxx/qla_mbx.c |  22 +++++--
>>  drivers/scsi/qla2xxx/qla_os.c  |  19 ++++--
>>  include/uapi/scsi/fc/fc_els.h  |   1 +
>>  6 files changed, 139 insertions(+), 42 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_d=
ef.h
>> index 172ea4e5887d..2e058ac4fec7 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -34,6 +34,8 @@
>>  #include <scsi/scsi_transport_fc.h>
>>  #include <scsi/scsi_bsg_fc.h>
>>  +#include <uapi/scsi/fc/fc_els.h>
>> +
>>  /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). =
*/
>>  typedef struct {
>>  	uint8_t domain;
>> @@ -1269,7 +1271,11 @@ static inline bool qla2xxx_is_valid_mbs(unsigned =
int mbs)
>>  #define RNID_TYPE_ASIC_TEMP	0xC
>>    #define ELS_CMD_MAP_SIZE	32
>> -#define ELS_COMMAND_RDP		0x18
>> +#define ELS_COMMAND_RDP		ELS_RDP
>> +/* Fabric Perf Impact Notification */
>> +#define ELS_COMMAND_FPIN	ELS_FPIN
>> +/* Read Diagnostic Functions */
>> +#define ELS_COMMAND_RDF		ELS_RDF
>=20
> there shouldn't be a need for a new define for these. The native ELS_xxx =
define should be used.
Was doing this to maintain uniformity, but I see the point, will change thi=
s.
>=20
>>    /*
>>   * Firmware state codes from get firmware state mailbox command
>> @@ -4487,10 +4493,19 @@ struct active_regions {
>>  #define QLA_SET_DATA_RATE_NOLR	1
>>  #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
>>  +#define QLA_DEFAULT_PAYLOAD_SIZE	64
>> +/*
>> + * This item might be allocated with a size > sizeof(struct purex_item)=
.
>> + * The "size" variable gives the size of the payload (which
>> + * is variable) starting at "iocb".
>> + */
>>  struct purex_item {
>>  	struct list_head list;
>>  	struct scsi_qla_host *vha;
>> -	void (*process_item)(struct scsi_qla_host *vha, void *pkt);
>> +	void (*process_item)(struct scsi_qla_host *vha,
>> +			     struct purex_item *pkt);
>> +	atomic_t in_use;
>> +	uint16_t size;
>>  	struct {
>>  		uint8_t iocb[64];
>>  	} iocb;
>> @@ -4690,6 +4705,7 @@ typedef struct scsi_qla_host {
>>  		struct list_head head;
>>  		spinlock_t lock;
>>  	} purex_list;
>> +	struct purex_item default_item;
>>    	struct name_list_extended gnl;
>>  	/* Count of active session/fcport */
>> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_g=
bl.h
>> index f62b71e47581..54d82f7d478f 100644
>> --- a/drivers/scsi/qla2xxx/qla_gbl.h
>> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
>> @@ -229,7 +229,8 @@ void qla2x00_handle_login_done_event(struct scsi_qla=
_host *, fc_port_t *,
>>  int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
>>  int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
>>  void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
>> -void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt);
>> +void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>> +			       struct purex_item *pkt);
>>    /*
>>   * Global Functions in qla_mid.c source file.
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_i=
sr.c
>> index a9e8513e1cf1..401ce0023cd5 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -31,35 +31,11 @@ const char *const port_state_str[] =3D {
>>  	"ONLINE"
>>  };
>>  -static void qla24xx_purex_iocb(scsi_qla_host_t *vha, void *pkt,
>> -	void (*process_item)(struct scsi_qla_host *vha, void *pkt))
>> -{
>> -	struct purex_list *list =3D &vha->purex_list;
>> -	struct purex_item *item;
>> -	ulong flags;
>> -
>> -	item =3D kzalloc(sizeof(*item), GFP_KERNEL);
>> -	if (!item) {
>> -		ql_log(ql_log_warn, vha, 0x5092,
>> -		    ">> Failed allocate purex list item.\n");
>> -		return;
>> -	}
>> -
>> -	item->vha =3D vha;
>> -	item->process_item =3D process_item;
>> -	memcpy(&item->iocb, pkt, sizeof(item->iocb));
>> -
>> -	spin_lock_irqsave(&list->lock, flags);
>> -	list_add_tail(&item->list, &list->head);
>> -	spin_unlock_irqrestore(&list->lock, flags);
>> -
>> -	set_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags);
>> -}
>> -
>>  static void
>> -qla24xx_process_abts(struct scsi_qla_host *vha, void *pkt)
>> +qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
>>  {
>> -	struct abts_entry_24xx *abts =3D pkt;
>> +	struct abts_entry_24xx *abts =3D
>> +	    (struct abts_entry_24xx *)&pkt->iocb;
>>  	struct qla_hw_data *ha =3D vha->hw;
>>  	struct els_entry_24xx *rsp_els;
>>  	struct abts_entry_24xx *abts_rsp;
>> @@ -790,6 +766,76 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint1=
6_t *mb)
>>  	}
>>  }
>>  +struct purex_item *
>> +qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>> +{
>> +	struct purex_item *item =3D NULL;
>> +	uint8_t item_hdr_size =3D sizeof(*item);
>> +	uint8_t default_usable =3D 0;
>> +
>> +	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
>> +		item =3D kzalloc(item_hdr_size +
>> +		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
>> +	} else {
>> +		item =3D kzalloc(item_hdr_size, GFP_ATOMIC);
> I thought GFP_ATOMICs are looked down upon as a last resort. This is repl=
acing code that used GFP_KERNEL.
The use of GFP_KERNEL was leading to a stack trace on some systems given th=
at this is invoked thru the interrupt handler, hence the change. Given that=
 the allocation is for a small size (64-128 bytes in general), and it has a=
 short life, we went on to use the GFP_ATOMIC.
>> +		default_usable =3D 1;
>> +	}
>> +	if (!item) {
>> +		if (default_usable &&
>> +		    (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1)) {
>> +			item =3D &vha->default_item;
>> +			goto initialize_purex_header;
>> +		}
>> +		ql_log(ql_log_warn, vha, 0x5092,
>> +		       ">> Failed allocate purex list item.\n");
>> +
>> +		return NULL;
>> +	}
>> +
>> +initialize_purex_header:
>> +	item->vha =3D vha;
>> +	item->size =3D size;
>> +	return item;
>> +}
>> +
>> +static void
>> +qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
>> +			 void (*process_item)(struct scsi_qla_host *vha,
>> +					      struct purex_item *pkt))
>> +{
>> +	struct purex_list *list =3D &vha->purex_list;
>> +	ulong flags;
>> +
>> +	pkt->process_item =3D process_item;
>> +
>> +	spin_lock_irqsave(&list->lock, flags);
>> +	list_add_tail(&pkt->list, &list->head);
>> +	spin_unlock_irqrestore(&list->lock, flags);
>> +
>> +	set_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags);
>> +}
>> +
>> +/**
>> + * qla24xx_copy_std_pkt() - Copy over purex ELS which is
>> + * contained in a single IOCB.
>> + * purex packet.
>> + * @vha: SCSI driver HA context
>> + * @pkt: ELS packet
>> + */
>> +struct purex_item
>> +*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>> +{
>> +	struct purex_item *item;
>> +
>> +	item =3D qla24xx_alloc_purex_item(vha,
>> +					QLA_DEFAULT_PAYLOAD_SIZE);
>> +	if (!item)
>> +		return item;
>> +
>> +	memcpy(&item->iocb, pkt, sizeof(item->iocb));
>> +	return item;
>> +}
>> +
>>  /**
>>   * qla2x00_async_event() - Process aynchronous events.
>>   * @vha: SCSI driver HA context
>> @@ -3233,6 +3279,7 @@ void qla24xx_process_response_queue(struct scsi_ql=
a_host *vha,
>>  {
>>  	struct sts_entry_24xx *pkt;
>>  	struct qla_hw_data *ha =3D vha->hw;
>> +	struct purex_item *pure_item;
>>    	if (!ha->flags.fw_started)
>>  		return;
>> @@ -3284,8 +3331,12 @@ void qla24xx_process_response_queue(struct scsi_q=
la_host *vha,
>>  			break;
>>  		case ABTS_RECV_24XX:
>>  			if (qla_ini_mode_enabled(vha)) {
>> -				qla24xx_purex_iocb(vha, pkt,
>> -				    qla24xx_process_abts);
>> +				pure_item =3D qla24xx_copy_std_pkt(vha, pkt);
>> +				if (!pure_item)
>> +					break;
>> +
>> +				qla24xx_queue_purex_item(vha, pure_item,
>> +							 qla24xx_process_abts);
>>  				break;
>>  			}
>>  			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
>> @@ -3342,7 +3393,12 @@ void qla24xx_process_response_queue(struct scsi_q=
la_host *vha,
>>  				    purex->els_frame_payload[3]);
>>  				break;
>>  			}
>> -			qla24xx_purex_iocb(vha, pkt, qla24xx_process_purex_rdp);
>> +			pure_item =3D qla24xx_copy_std_pkt(vha, pkt);
>> +			if (!pure_item)
>> +				break;
>> +
>> +			qla24xx_queue_purex_item(vha, pure_item,
>> +						 qla24xx_process_purex_rdp);
>>  			break;
>>  		}
>>  		default:
>> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_m=
bx.c
>> index 9fd83d1bffe0..a1f899bb8c94 100644
>> --- a/drivers/scsi/qla2xxx/qla_mbx.c
>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
>> @@ -59,6 +59,7 @@ static struct rom_cmd {
>>  	{ MBC_IOCB_COMMAND_A64 },
>>  	{ MBC_GET_ADAPTER_LOOP_ID },
>>  	{ MBC_READ_SFP },
>> +	{ MBC_SET_RNID_PARAMS },
>>  	{ MBC_GET_RNID_PARAMS },
>>  	{ MBC_GET_SET_ZIO_THRESHOLD },
>>  };
>> @@ -4867,6 +4868,7 @@ qla24xx_get_port_login_templ(scsi_qla_host_t *vha,=
 dma_addr_t buf_dma,
>>  	return rval;
>>  }
>>  +#define PUREX_CMD_COUNT	2
>>  int
>>  qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
>>  {
>> @@ -4875,12 +4877,12 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *=
vha)
>>  	mbx_cmd_t *mcp =3D &mc;
>>  	uint8_t *els_cmd_map;
>>  	dma_addr_t els_cmd_map_dma;
>> -	uint cmd_opcode =3D ELS_COMMAND_RDP;
>> -	uint index =3D cmd_opcode / 8;
>> -	uint bit =3D cmd_opcode % 8;
>> +	uint cmd_opcode[PUREX_CMD_COUNT];
>> +	uint i, index, purex_bit;
>>  	struct qla_hw_data *ha =3D vha->hw;
>>  -	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) && !IS_QLA27XX(ha))
>> +	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
>> +	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
>>  		return QLA_SUCCESS;
>>    	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
>> @@ -4896,7 +4898,17 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *v=
ha)
>>    	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
>>  -	els_cmd_map[index] |=3D 1 << bit;
>> +	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
>> +
>> +	/* List of Purex ELS */
>> +	cmd_opcode[0] =3D ELS_COMMAND_FPIN;
>> +	cmd_opcode[1] =3D ELS_COMMAND_RDP;
> need to deal with endianness on this assigment ?   8bit values going into=
 a uint ?
Agree, will address.
>> +
>> +	for (i =3D 0; i < PUREX_CMD_COUNT; i++) {
>> +		index =3D cmd_opcode[i] / 8;
>> +		purex_bit =3D cmd_opcode[i] % 8;
>> +		els_cmd_map[index] |=3D 1 << purex_bit;
>> +	}
>>    	mcp->mb[0] =3D MBC_SET_RNID_PARAMS;
>>  	mcp->mb[1] =3D RNID_TYPE_ELS_CMD << 8;
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os=
.c
>> index 382e1f977d01..007f39128dbf 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -5891,10 +5891,12 @@ qla25xx_rdp_port_speed_currently(struct qla_hw_d=
ata *ha)
>>   * vha:	SCSI qla host
>>   * purex: RDP request received by HBA
>>   */
>> -void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
>> +void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>> +			       struct purex_item *item)
>>  {
>>  	struct qla_hw_data *ha =3D vha->hw;
>> -	struct purex_entry_24xx *purex =3D pkt;
>> +	struct purex_entry_24xx *purex =3D
>> +	    (struct purex_entry_24xx *)&item->iocb;
>>  	dma_addr_t rsp_els_dma;
>>  	dma_addr_t rsp_payload_dma;
>>  	dma_addr_t stat_dma;
>> @@ -6304,6 +6306,15 @@ void qla24xx_process_purex_rdp(struct scsi_qla_ho=
st *vha, void *pkt)
>>  		    rsp_els, rsp_els_dma);
>>  }
>>  +void
>> +qla24xx_free_purex_item(struct purex_item *item)
>> +{
>> +	if (item =3D=3D &item->vha->default_item)
>> +		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
>> +	else
>> +		kfree(item);
>> +}
>> +
>>  void qla24xx_process_purex_list(struct purex_list *list)
>>  {
>>  	struct list_head head =3D LIST_HEAD_INIT(head);
>> @@ -6316,8 +6327,8 @@ void qla24xx_process_purex_list(struct purex_list =
*list)
>>    	list_for_each_entry_safe(item, next, &head, list) {
>>  		list_del(&item->list);
>> -		item->process_item(item->vha, &item->iocb);
>> -		kfree(item);
>> +		item->process_item(item->vha, item);
>> +		qla24xx_free_purex_item(item);
>>  	}
>>  }
>>  diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_el=
s.h
>> index 66318c44acd7..cb7ffc37c4f9 100644
>> --- a/include/uapi/scsi/fc/fc_els.h
>> +++ b/include/uapi/scsi/fc/fc_els.h
>> @@ -41,6 +41,7 @@ enum fc_els_cmd {
>>  	ELS_REC =3D	0x13,	/* read exchange concise */
>>  	ELS_SRR =3D	0x14,	/* sequence retransmission request */
>>  	ELS_FPIN =3D	0x16,	/* Fabric Performance Impact Notification */
>> +	ELS_RDP =3D	0x18,	/* Read Diagnostic Parameters */
>>  	ELS_RDF =3D	0x19,	/* Register Diagnostic Functions */
>>  	ELS_PRLI =3D	0x20,	/* process login */
>>  	ELS_PRLO =3D	0x21,	/* process logout */
> you're missing the :
>   [ELS_RDP] =3D    "RDP",                 \
>=20
> line in the respective location of FC_ELS_CMDS_INIT
Agree, will address.
>=20
> -- james

