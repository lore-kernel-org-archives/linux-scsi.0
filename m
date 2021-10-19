Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F409C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 15:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 570CD61154
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 15:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhJSP5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:57:19 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:52400 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhJSP5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 11:57:18 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JCcPc1019220;
        Tue, 19 Oct 2021 15:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=PPS06212021;
 bh=YJjvzsxrUXOYv9C6sgh98ss5g/DDVAWUmyP6oVX7nyA=;
 b=coRjP1BOAp//18+yqaXd9d9ioAiYixv7xIek81tmypmtSztC6rDflUcohuvQD377dQkC
 RcJ2au8dH5hqvgWnF3xnaGgOCgVjm0B3B9JbCkp0pMKB+RCkChVY9lPsinbLeEJTOkV7
 Fx0aPxLzdZ9oEhzDmFxh/BGcBr9Hb9psxBXrP32Pp4zREDgqgLyTc6N+5RgWaktvORFy
 lnQUobVmIcpyn8yxfboVdKXTyXwItjXAmDeRU8zCHWi1sZcThkVxA45R+xbyFDh0NpDz
 OnYiFcPMPsEMYxmyCHcvdBTfveqlVFC+dVlMJmbuEh/Tl32NFtU2qOVVFmabc0wnMsQR XA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bs6hhh87h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 15:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEwChfGT/hPCZv/r+2RYvSsvk5VHf+xFTwcUPD2gO+c+vurkgDci84BhgpcrUohC+6e3U3oXE3+Gx4NgNcv695oCsoY1A4rIB1WtuhoFlqJmd9vg5yUpr3CiOiT9DxUo2QIf59I3MeJeL2dhiqRLxLGivesP2LxMkK61hGy+6RjpLG5NGdbDsSJt3/NLgW8+TpiDSdkKMQM31K3khHfrJWM96VEtqdpJiC1XsHDsKo8rGXT1D6T04yGBAZLWgNJpcJKG7VDtydCbkwMLJTSW7K1gDZhuhwd+5XPmaJan1k2XL7K5oS9HQWQ93ZjujI7g/jvm4KFRQmv1p/zAhUuEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJjvzsxrUXOYv9C6sgh98ss5g/DDVAWUmyP6oVX7nyA=;
 b=P1OoCB0naD8WKAbzuLCzT9+zxvo+JqwI1WZZ4HIBIfs0pNcv/ViqBpPwftelnbe55HjkAm2WG8bnGWfn0UqadwyEERIC2hvUg3Ewlsd0Jgym3ONYiPrvewzMuuddcTkU/jewRkfzQe6IVHfJm13eWBIMqQ34kXZU6007+8A9r6RTb2SUrLtx5fxMKltVoilqrtjqAGhIECLmqzHFWRPe49/0lxY61s8WoEkX3fB9/dY30+caw/JseD5Ok+6HTwGqs0WQnc/V1A8b4Kxb/DvMIwF6p5omyU5xl/c8/kddSmqNYYua3iomdo9uG7Smq3j1dAzUm7w8YQHtuSmIo/tU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM5PR11MB1531.namprd11.prod.outlook.com (2603:10b6:4:10::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 15:54:57 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::83e:b336:7689:d157]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::83e:b336:7689:d157%2]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 15:54:57 +0000
Date:   Tue, 19 Oct 2021 11:54:53 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     "Ma, Jiping" <jiping.ma2@windriver.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        scott.benesh@microchip.com, don.brace@microchip.com,
        scott.teel@microchip.com, kevin.barnett@microchip.com,
        Murthy.Bhat@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yue.tao@windriver.com
Subject: Re: [PATCH] scsi: smartpqi: Enable sas_address sys fs for SATA
 device type.
Message-ID: <20211019155449.GA30330@windriver.com>
References: <20211011024611.152626-1-jiping.ma2@windriver.com>
 <79269170-c390-5914-54b9-f562eb463505@windriver.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79269170-c390-5914-54b9-f562eb463505@windriver.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: YT3PR01CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::16) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
Received: from windriver.com (128.224.252.2) by YT3PR01CA0039.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:82::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Tue, 19 Oct 2021 15:54:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a40cd65e-7fee-4d8b-7cbc-08d99318cc55
X-MS-TrafficTypeDiagnostic: DM5PR11MB1531:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR11MB1531A9E80CC7DEC1B19FF7F083BD9@DM5PR11MB1531.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tlwFbkBaYWxDslclg89mq5DThkBRCe2eQj3Lgmh11/wWRaPajO8FGi2535I4hmAjk6qbll7LYkmfkAxfGqP9RriEolw6IK7K0fWqKrFT+KSUwgebawfvKdNlsTvaf0QMuA8/wDFImb/eEjiDgijxyayySbLyFBQifZ1BgpKPzD2Ks9pAzbv7xYXS7tcLDs4U3iWnJuwf27xiKeSIw9muPVHRFPK5uQnLrvRtGWgG5RnKS4gqwA0wNE/aB4wtz4IEdC8Q5zjNqwtwtzxxHSx9aNpdiQao+//CPlPQ7yjuV+Efagzzz7XqnrxlGgA9+iv9YBV+LVh0SGtXR1Am0g1m0sXleioD6Drs6vlBVBYmrqD/UXLdgVZoDnN9eycVQtlussEEtl9J6w4TmLyXHvIMUrOr+vNNLYspcwigI+CE+623V7iRnGFOM4FaXCHkRY8/xYPbZtJaixmiDhTUXnRkHX9kaQVtNw7sDyYjwsRQuXKR/OmzggA5myNYIsKjUgsTRXx9R3d6lqPMSMMiacjAZrmHNrzNuxmwjElBEYiuspSwhazStJvNgXnwOYOWJPndNOKaC92gTwcoNQO6q0EYOj5Ffx87D6ArXbgFxqYQ1Sv0m4mdUYo79icitPoFehAYIi1UyrgYCQuL3Vw1VR967twF6VhJ5Sn5ScjOtqdJyocpcGlAsy3RGyvKBe3QD78dHoXejvO8Fg9U5X8DBXZQTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6862004)(55016002)(33656002)(1076003)(86362001)(53546011)(83380400001)(36756003)(5660300002)(107886003)(8886007)(6636002)(2906002)(8676002)(4326008)(44832011)(956004)(66556008)(38100700002)(38350700002)(66476007)(8936002)(186003)(26005)(316002)(66946007)(2616005)(37006003)(52116002)(6666004)(508600001)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4yG6YaoFI9vHV/M6hw5lvLY0x49icDFPQSCMIY3dgPDS4huQzmzA1C0UEW2O?=
 =?us-ascii?Q?6cfQdeONLi3X8TTL0ntoYF1ciCA55hlvsu3EiYd7FU2k4WtDmFZHmZWVR6fW?=
 =?us-ascii?Q?Uw6KGPSH4gCJQcMgWTtc1RLGcUNAISKZCwDuKjshEWS94TuF++nQQBuVckHi?=
 =?us-ascii?Q?BODU2MhMJ/AhZ8vfM/db9IZxQlSv4eP4sEYlSiHqqxfGsXIejJRT0zTNOIml?=
 =?us-ascii?Q?aIrgxOMwipEMSYOdsZwSEWMpQVS8IuCWmkLp8uxmillXkMD3zag4yVXTd6SI?=
 =?us-ascii?Q?xnt8ZLmsuhg0+Se2+CexUyNsfIl8VRYrHWG7c6QRAhXQ9kGXud4UnASYU3Nh?=
 =?us-ascii?Q?XP+OTfEYU86SnkqwrEHnXhSJR0lBfMms6xLPf0IdiIJ7PIftt7MwaiD8PXr7?=
 =?us-ascii?Q?GJlI93FAfoHCL5ZRrO8Pg+xrrK5755Ci7oLYWboe+XoEu8YNCNbGl7ZB0JI0?=
 =?us-ascii?Q?yVIVne+JJj6H37METB4sVfqwEtuoM1rLw+1NJ2xWC89XREi8jf3TJ1pffLzo?=
 =?us-ascii?Q?1k99pOvBSGcf1bYFKjpDQIDepm6c9bYi+LYwrWjfhIFyxdTq1Ppavo+XMocc?=
 =?us-ascii?Q?pt6Mn1EpJROTzh25WInTXjXM8vVWkITm4JKu3T03l4AENPlpCQIcr0AbgLYJ?=
 =?us-ascii?Q?o20z/aIgpgvRsPJMmaazZ63nElfPiai+hk+xkN2seKBidvX3CWrSvNSjh8n6?=
 =?us-ascii?Q?fMuGxDVcHtsbNk4tke9omPa4TORd6MIX5IHLNJjSnPZP5xIqTuXaDGoPWBAL?=
 =?us-ascii?Q?KeCeXh8663GMbi+UbdTLnNh185Q3JdmKkyLB5nR+VOkWg7GSzKnhXHwZYEja?=
 =?us-ascii?Q?HuikJ7XTB/pi/VFLCYdVOXQjEvTcslLKF7PsyU6oFX9OlRoSJdBUe58melMC?=
 =?us-ascii?Q?3IUv2+TAfM/GVki67YeNct62Rznz7VHTnDI3hKHl2ZWs5EqBfh1NHrJkJtU2?=
 =?us-ascii?Q?FUjUHshPj53RWA/SDHfHhfD08hcwFcY4HU+KkDhirFw9EC8Q2uMLqr+Cj+iY?=
 =?us-ascii?Q?kWJbjhmOvC+dtavi/7F2k933fdxcCYU2GS7dkzkYibP5eBlP+Y9aOaKb1yAA?=
 =?us-ascii?Q?bRLuj4KrXQYV7Cx+SsOzhHDN39rP4d+JJoGtqvDkwmkAHYQSe6PSqwaYvOJm?=
 =?us-ascii?Q?ommGewbmPSy7Y6VZO20IAj5QeBAw81VAVX/P24vhHKSkNfNfmoK3/piyOnJS?=
 =?us-ascii?Q?GwwwrQllNdETD0GXn0XmTxJOx2YSZO5KTWFgwudsGSXY2HZlIUS3wVZxAm1O?=
 =?us-ascii?Q?q5Tg/ZEVIuy3mZHHiX3S6h0CGxTrpcT6sFJE+JtJC/hlcZpBjl2PvTLb+BrV?=
 =?us-ascii?Q?evo4fOqIkVLA+jmUFwpvMBMl?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a40cd65e-7fee-4d8b-7cbc-08d99318cc55
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 15:54:56.8518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1wLYQVtrJ6PZNVKNmagIeniArnXchFB6Fi0aevC9B7J+3+opuWEF77u1KqgsCY16C2pzoBdUnwnAWyBntdEbuRD14OTK6kiavaXhyZkq6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1531
X-Proofpoint-ORIG-GUID: Z6ttrPgGUwGS_dcTTtM4WhA7HvtQug9b
X-Proofpoint-GUID: Z6ttrPgGUwGS_dcTTtM4WhA7HvtQug9b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[Re: [PATCH] scsi: smartpqi: Enable sas_address sys fs for SATA device type.] On 14/10/2021 (Thu 08:44) Ma, Jiping wrote:

> ping
> 
> Thanks,

If you want prompt responses, you can help yourself by writing proper
commit logs that don't assume everyone has the exact same context in
their mind that you have on your specific problem.

Start with a clear problem statement that covers the symptoms.

  "When I connect device type ABC to host XYZ, I can't do foobar,
   because I get <describe symptoms here>"

Then describe the technical "why" it happens, showing that you
understand what is going on.

  "This happens because device types ABC are excluded from being
  treated/processed with <functions/code/whatever>"

Finally describe what your chosen fix is and why it is the best possible
choice to fix things, with the least risk of side effects.

  "We can add type ABC to class foobar, since it supports all the
   basic functions of class XYZ and works transparently without gaps."

Additional details like command line output are good, but you shouldn't
fill the commit log with nothing but them.   Be concise when adding
captured output - only show what needs to be shown.

Finally, don't send a "ping" only a couple days after your original
send.  Speaking for myself, if someone does that to me, they immediately
go to the end of my queue.   Maintainers are busy.  Be patient and
polite and write good commit logs and things will probably go a lot
better for you.

Paul.
--

> 
> Jiping
> 
> On 10/11/2021 10:46 AM, Jiping Ma wrote:
> > Current version:
> > /sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
> > find -name sas_address -print -exec cat {} \;
> > ./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
> > 0x0000000000000000
> > ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
> > cat: ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address:
> > No such device
> > ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
> > cat: ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address:
> > No such device
> > ./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
> > 0x0000000000000000
> > ./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
> > 0x0000000000000000
> > ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
> > cat: ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address:
> > No such device
> > ./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
> > 0x0000000000000000
> > ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
> > cat: ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address:
> > No such device
> > 
> > After patch applied:
> > /sys/devices/pci0000:36/0000:36:02.0/0000:3b:00.0/host0/scsi_host/host0$
> > find -name sas_address -print -exec cat {} \;
> > ./port-0:3/end_device-0:3/sas_device/end_device-0:3/sas_address
> > 0x31402ec001d92985
> > ./port-0:3/end_device-0:3/target0:0:2/0:0:2:0/sas_address
> > 0x31402ec001d92985
> > ./port-0:1/end_device-0:1/target0:0:0/0:0:0:0/sas_address
> > 0x31402ec001d92983
> > ./port-0:1/end_device-0:1/sas_device/end_device-0:1/sas_address
> > 0x31402ec001d92983
> > ./port-0:4/end_device-0:4/sas_device/end_device-0:4/sas_address
> > 0x31402ec001d92986
> > ./port-0:4/end_device-0:4/target0:0:3/0:0:3:0/sas_address
> > 0x31402ec001d92986
> > ./port-0:2/end_device-0:2/sas_device/end_device-0:2/sas_address
> > 0x31402ec001d92984
> > ./port-0:2/end_device-0:2/target0:0:1/0:0:1:0/sas_address
> > 0x31402ec001d92984
> > 
> > Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
> > ---
> >   drivers/scsi/smartpqi/smartpqi_init.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> > index ecb2af3f43ca..df16e0a27a41 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -2101,6 +2101,7 @@ static inline void pqi_mask_device(u8 *scsi3addr)
> >   static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
> >   {
> >   	switch (device->device_type) {
> > +	case SA_DEVICE_TYPE_SATA:
> >   	case SA_DEVICE_TYPE_SAS:
> >   	case SA_DEVICE_TYPE_EXPANDER_SMP:
> >   	case SA_DEVICE_TYPE_SES:
