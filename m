Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069E2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiBOD3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:29:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiBOD3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:29:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF2583001
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:29:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2TqZ9014923;
        Tue, 15 Feb 2022 03:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+lP+vvF10c6HOYZ3yQvyMtN/9Ez8zjvfQpNZYOYjiCQ=;
 b=HQpaMik74O7ASmG3JtLfldRWVayGRjMbn4TtYhHsNNAppdHpTerJPexQ9k9XC4Ntl/iF
 Sv1NskwkVszkNBn1rqIzcTUYekPB1MUOhOStKrxicAQ0mpdNyfEdCUdyMZH2KdzyUE86
 ujhIL/epI6/bUNBU2Q6hkxnAu6W8hnvr3k0n5YGKZLdSbq0zM7jfaQO9kOJaDi8D9SDl
 YsKu0B3HlGKD7xR8JupmEJnQyBGWWJn+cxZ2LA+JvYbEGUDdiJ7O/3BUnwHWAGY2Rrrf
 ZJs2EWyeMDbrSOt8ajoVqxEbFSB6VPljFpInXU5UsosIDjv0ZE3mSYOUQsuVmei0SE3M 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt6eks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:29:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GsgV058003;
        Tue, 15 Feb 2022 03:29:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3e620wpmq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZUvbkqp/qR8VKht8v1ZqnHHOVHpNIje8J4oYlh+nEEyhXBTFS+Aj33mrpptLTjnEs5zerPEhX+4AZ0ffXyn03fS1gI5GzTmyI0R8nhbhEdjPUrm9xPVFcHBStVr4YSEhXUSGc/OIE0QRqr7IdpT4KFJN6B8vScNc3vtsy6xnf6eTMmaYV5qTfd0ci1sFaKIBELmMU9pWNRX9iDFWkCorWZy6X2ctccdWgFLUkhtSJ1+jvrtwtFbwJupBCVWXkhrZoUkp4Zf7eew9SFrlr3COsTuJxIYrxVuvHvOjoBnfFkIy4FmWirsVR65MUgGH8mDG3v/2CF4X11A/1HPOLyGlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lP+vvF10c6HOYZ3yQvyMtN/9Ez8zjvfQpNZYOYjiCQ=;
 b=Woxzny9Yb7YuPCWL+kbvgbifBFWSjHXQskR7JAogZmBM6SJ6Nw6aPLwBZwnrmKYGJuBUWs6LdCHQjnDJdJ6seZk547wjRcn5Da4U14B32T6lOcSG8j7Nz2npfVnZTjjKz4BtlPZU0CGu1DZ+3Li4DptYzCDDGsbsh6f60wgyb1gYFeP77uDHA89JtpPLQPngvNzTJDcPdZI3tScW0lKQlYJ82XL4ns25uk8K3Xh56UnmnhmFRqs0tUTKYlkPUVHP/CE/BC5igCF3o6VT3UQ97WXWmmeA2sl/uoTfCoAN237YZOyjr67qeO6F0kVFfo5yC6Jk9c8n2VnYyuDQf1l+2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lP+vvF10c6HOYZ3yQvyMtN/9Ez8zjvfQpNZYOYjiCQ=;
 b=jEjcM23pxxFowUkyaFV8jd/CxQGGugKOeK7ZVvVLNO5Jd6e6dFDvt9GgwelPVAF313iWlfd2J/mfkoufEuExXBQZejM6L9qyzwJc51dbnAjr06O6FBE83l4mx1HfYTWqocLuIgpGysbvNx4XexmMvbppqRhQhfEOSJdh4d8w1os=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB2008.namprd10.prod.outlook.com (2603:10b6:903:11e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 03:29:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 03:29:06 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: Fix runtime PM messages never-ending cycle
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k50n7b0.fsf@ca-mkp.ca.oracle.com>
References: <20220214121941.296034-1-adrian.hunter@intel.com>
Date:   Mon, 14 Feb 2022 22:29:04 -0500
In-Reply-To: <20220214121941.296034-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Mon, 14 Feb 2022 14:19:41 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:806:f2::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b63a220d-71cd-4bc1-9fb8-08d9f03351ed
X-MS-TrafficTypeDiagnostic: CY4PR10MB2008:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB20089C0280DB2710ADCA8FD48E349@CY4PR10MB2008.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPEuzWcH4pLtXN+HGEo5pe/X5sY9PDCiwGRpQ9WJvYbQ063AMxFF4t4pkDAvoz6s8S6lCwyu6ksLAHsOAgMmA5Wi05N30oAiL5zxkI7U8jUW+xfkXSeVF/ayryxUxpV5m96BXxZm9KKDRNRk2Cfxs9xGAxCbTNXVs6oMAVJy5+ICWIPOU6hLa4lsD6umuKW8HExHog4BF8qpdEmz5m549hHzHP/VCZvb6i4ZCduZjBxDWoBkX1aCWJkykLSbPK3WDjwPmvFqYfI3Exmmjq/iyo0YXpIJq9DtJxQ2WZN2A/LbpIY+IZEhCoMcvBQ9Udzp65SgrDwNwUTUSKLBeMwWq5/vydqSmwX+dA5oLu2TVpu7hKrYF8T9AH/pWmJ/gOR+WgftIPvB0Otl8MSynoAiF7dOrwEXo69Hwd982apU9S33AN0w0MNoYBk0hGrq99Lo4Bw4EWxIKQn9227YHT3wugWxlqiyobim6GrZ3uzb4EOc3gDSmlNLr9Atadm7AF8sEpQfDw7tZKONaiv0JNwoNJqS7j1552XzVplpVYyKZx+jMk4lAD6H9u1FVkI2bkeWjgOvCN/TxtmiLMlD4ZnE9FjrCjsl5hFHHEVrA0q+uNgSN3ca9OTQDlPcW1du6mdkckMSkIQuQs2SwxV2mZ1WwIRmtf4Z1Y+jM1VmRxqwOSNNS3dtxNUWxEkMke6tNFs7TJSmbsglUZQMBBBB+dRhQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(15650500001)(38350700002)(36916002)(8936002)(52116002)(66946007)(66556008)(6486002)(66476007)(8676002)(508600001)(4326008)(316002)(186003)(6506007)(83380400001)(26005)(86362001)(54906003)(2906002)(6916009)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LG458SWljSmnTim+OEc272tWfclzzPxMASedD7wyHIEEuPARpQRXAb9B0nq5?=
 =?us-ascii?Q?38C/0Lj3xFeiGA2OjbLWDA12kK6Ikg0mtl1aU84ojMRQS8KY/nqDk/nhJIBj?=
 =?us-ascii?Q?0vxecTttdWyG9s6+Muh9i53+mH+x/0fyGdcztNU0lhVvu1bmnBWn0qVofRN+?=
 =?us-ascii?Q?WOgAYN27KzQJ8onDl7bTuoL0U8gDQu7OHYlLx0jr69WO9mZKhhbb+0C2LKgR?=
 =?us-ascii?Q?NsKntClXMLtIfXFYT+4J5wNYrnIE1eF+/NrTGx5i+JwKwbAUQH8V8r7h65XF?=
 =?us-ascii?Q?JTOFP08N05rN2/2eWyDWRVVqD8JvwhB+/u1+K7bsw60H3cppFgsbxHJjoC7S?=
 =?us-ascii?Q?0HNB3bEze87RlPwQplSr4gFUx0BNjotXwy1WND7JKb1lwsi+1O1w9cQ0f5Eg?=
 =?us-ascii?Q?PkZKCRpTfQ3BJhBXFq+w5L7ymAMIOacrDowccihBE1+YUSD8GSfGaQtbCBhG?=
 =?us-ascii?Q?IbhWRArF10aHpydX162m0+EvjIIqjUA1dyfF0mNx9btX6x5l3o8jgFTEX/AU?=
 =?us-ascii?Q?ZXGBM7C5ZvH7NPHfNDOcMMNObRX/EmkhrWIkl2Mv7Lp67KyaTUcJPf0Jxiy4?=
 =?us-ascii?Q?3bec4+ydmV7S+I2LGedryBut33gsAkI2OD9L+wJ8uAsTiHU4c7Yo0oelPYSo?=
 =?us-ascii?Q?5ZCnkPNXZ7WYX68uVaQEAJbZFITETyheU9EvrX9CMjh6MbbRCPW39IipnaJn?=
 =?us-ascii?Q?dr+w3QqnYiJ/gv2l+O9UzB7AxG31k+gKZxSScpF0No2DPsFqs6WxHKxLtq2s?=
 =?us-ascii?Q?bwXLJwno9DBeg31n+HoL8T/GmCNXHiBv7Cki0daAWmsm05mSH5MGBpQHt3mk?=
 =?us-ascii?Q?aL0OObkKnvRT/PHLutALCW/FwpndEt5uJt+cixCB2+hkCKhvCKI54GtPzQj3?=
 =?us-ascii?Q?pfLjz+ZARyByljMBaXyVaCyQtgyJMyK1W1vG1D4uEbxxWbI9PJ2dXKyW8oRS?=
 =?us-ascii?Q?IJ1JqVD6VfRrV1fxAU+r4EL9ultLA0IDkUwhI18eXQji8j/mp+a5pzybwVKV?=
 =?us-ascii?Q?hm4nClpfIT09cJm1rR09teFzSkzMgEmmsKOGG3llLHzmgdP755jM7ppBfcPq?=
 =?us-ascii?Q?OKXbYQccTlEMp1KtMGc54/QoOZWM4naCnlwE3PBP5jVDZEca0Im+KJdpMdJE?=
 =?us-ascii?Q?Z9P4au4DPvfDvgtVnzJQjWc2QStSeKluX+SWZV0hQxwxgFMzCyYiKmfYP5fG?=
 =?us-ascii?Q?Ku6rAcfniaoQNi9JLUVY4DlYNf1VoZ7iMm1cxtceFoWwAjcMofaWUQ3fPUdo?=
 =?us-ascii?Q?nCmstF7Zg/sE4hqd4Uw2tVLfaAn9stla9gp2VtKIXCc1ZaXAOJBw0bASXnMt?=
 =?us-ascii?Q?SLsP87LwUhX9fjmqpP9Xq/5al3dTKkNk+dtFww64Gd1waf24RCKfZmzaS+S8?=
 =?us-ascii?Q?lYqxLUwK0BMHOmnzMO8mIkvKtQCC16FF9695wCJowjcrQ1iqkjE2MkcSQVmz?=
 =?us-ascii?Q?u5YznXH2k6xLx1vRCqLm+po3MVq0NgjWT+kNDdvdJAZhH11umaMuyyHfzUys?=
 =?us-ascii?Q?Z55Xc83ymbBiXCUdBmJ8G80xnayjcdW3X+Z7ny7etH9bYoguVqK4kjeQbFX6?=
 =?us-ascii?Q?a4UKcexPCvMdMwspWctxa/z99BoyYXgWPQCuZLs2WXNdSgovIctTWxY0BbUX?=
 =?us-ascii?Q?ISMrKtPUlwfz6S2FS0mobfyZQ0MabR6jZQDE8b9MHSHvT9pB8tfTywrNbAMk?=
 =?us-ascii?Q?4/vksQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63a220d-71cd-4bc1-9fb8-08d9f03351ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 03:29:05.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJhK2RMrmYVO3pMiUpVZCApGeVRGZiUfiomBpfHv9YxfAqf6Qy/PmrKMveRy9nKD4vkx+428kzk1zNPhivJKYviesoMNbz+gEELzngDXyns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB2008
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150015
X-Proofpoint-GUID: FhDw6ZrqDC8W0LVRAgmHLXRUY8MYZebm
X-Proofpoint-ORIG-GUID: FhDw6ZrqDC8W0LVRAgmHLXRUY8MYZebm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Kernel messages produced during runtime PM can cause a never-ending
> cycle because user space utilities (e.g. journald or rsyslog) write the
> messages back to storage, causing runtime resume, more messages, and so
> on.
>
> Messages that tell of things that are expected to happen, are arguably
> unnecessary, so suppress them.

I don't have a major objection to the sd_suspend changes although I
wonder if there is a log level configuration problem with these systems?
Would KERN_INFO instead of KERN_NOTICE help?

I do not like the report sense change. We see this message all the time
in the field and it is very useful for debugging problems. So that
message should be made conditional based on PM state.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 60a6ae9d1219..e177dc5cc69a 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -484,8 +484,14 @@ static void scsi_report_sense(struct scsi_device *sdev,
>  
>  		if (sshdr->asc == 0x29) {
>  			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
> -			sdev_printk(KERN_WARNING, sdev,
> -				    "Power-on or device reset occurred\n");
> +			/*
> +			 * Do not print a message here because reset can be an
> +			 * expected side-effect of runtime PM. Do not print
> +			 * messages due to runtime PM to avoid never-ending
> +			 * cycles of messages written back to storage by user
> +			 * space causing runtime resume, causing more messages
> +			 * and so on.
> +			 */
>  		}
>  
>  		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {

-- 
Martin K. Petersen	Oracle Linux Engineering
