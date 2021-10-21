Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5891C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9525F60FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJUDYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:24:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34680 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhJUDYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:24:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1BlUq025799;
        Thu, 21 Oct 2021 03:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VrWtAjgkwiPI5znYXA/ZLIS4DmNOo0CMW/4y9LjDCww=;
 b=qiKwhIjeM4pK51qHNaZbk2AejRL4mfPpC/dJjufm2etxQAsJ/FhB708NyN3Bd8sRKU9m
 OobwoByGAB3X4sjZkoUVD4SkjmcFBIkLAtEgK8lt/ITDx5Ni/E+3/3y/R3QsRDiO9SUN
 8ucqkRW7rh/tQtY0tuf2kD0C3VmX1SDpRickbRXIf3qQ1esjleYGjAYeLuWp/ZzxolAF
 2sxMBSjhqM4yB9fnfRGNpArrU56/zx3tAildCfzhpi7pOVt9ZlisHlWcoaWhRriPvZ1w
 pmRNEo8zycXprFtmNCMzc/dSZuSzqoXm4Yua+uAa3B8SNz4b2OUIiO+6yKhZiaWsgDN7 gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm26yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:22:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3LbGs084162;
        Thu, 21 Oct 2021 03:21:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by userp3020.oracle.com with ESMTP id 3br8gv7k8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:21:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwiCbsW0qTb/R+1wXrfYNlA765bKhX9CjftOBUIdPEtWg0GzDSplcITye1V8yVUtE7di6SX5ldgykL7EA8S+xLyX62xlJuvnFY5VIE2pOEQp51gFKraD65SNcdqKlhddtovRy4z6YKHxHXSIClgyYCIz983O6/dKkqBBpDoQOOZQAud4ohJSS7imvqKFBf3eetLXrn/UQcZr05Fzw37We6bSSxn5jz98FpZbnU5YsB+NrxZf6zoUtC7I0MH8d14+6E66GcIkkwpFG9e1e0WRbpxb4lAKnhkgA3ZZprdKl+cmX7Iy2YqbLAJ5sTd9WI15DEnT7WMkNJfPF3cs/qfqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrWtAjgkwiPI5znYXA/ZLIS4DmNOo0CMW/4y9LjDCww=;
 b=D9z+FEGrE06KxRWGFfTqLads6GqFJYMIaLmsSVhJ7h4VRBPijl8JmIU3JMvsNjH1SNWxYOtYdNSsqThJoMYTFs9cJp0DLv8JVgx+6gIehcvNZvLCJ7KmlXZFYA8rWXUe+kz3IiIYYpdBu5XNDQ4tLScSwnVwaVvdY8J7r6tPgs07bQbi/7qX0sFU6tKQW79b5zYG1cRpRH5iD7s0JMX5rX4chyyo8DIE7dqI5KDRkQgd0ZS8IMCgzKYHiUoPxTJnNwD3y7w3ELCPmRH249/ZJ7CjlCB2goD+z3CrF7ZK06Oi3i4zHaLdUNB28FbHf1vVklUp0VjrAj6i58jzOob5MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrWtAjgkwiPI5znYXA/ZLIS4DmNOo0CMW/4y9LjDCww=;
 b=spKCY6oq9AAvQKLS1ugavgErdZEo2fGTiulvb+iKzUJ04WhsHra3P3rr1p7GledOtV9lLtAJW0FkyiGUoaMfhEVkG45X/ZPWOoj+wungeO9AO+s3pt7P1meHn96m6T/WAZAhxkp6h0AvLXqexW4EEZ2BC59gr7tirRVNWroSCuc=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 03:21:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 03:21:57 +0000
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH 1/2] scsi: target: core: Add sense reason for space
 allocation errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmrz6pbl.fsf@ca-mkp.ca.oracle.com>
References: <20211020184319.588002-1-k.shelekhin@yadro.com>
        <20211020184319.588002-2-k.shelekhin@yadro.com>
Date:   Wed, 20 Oct 2021 23:21:54 -0400
In-Reply-To: <20211020184319.588002-2-k.shelekhin@yadro.com> (Konstantin
        Shelekhin's message of "Wed, 20 Oct 2021 21:43:18 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:d3::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SA0PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:d3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 21 Oct 2021 03:21:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3864ba29-4270-474e-87b2-08d99441efd1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-Microsoft-Antispam-PRVS: <PH0PR10MB46617B35A9811666BBF8F0038EBF9@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEMoXo21u/fDTXYQcTNebZGXE94P2NBmfh5fHiGoxYj3JFZx+Gwgs4t/FusyBjqEmrXtgOZ/gTU47HbvjXUKpww3LQRYrRR0zxd0CB5pC5Vo37sT4qQL8qSHr7zkFwcckQISRxdeFVkY+kIrjD/hEdSsdReG8XCj917thWx5VE10e/27aj1CLI2pn7RiBGtOoEFoYsSqI0ZlU3e0kj4HO0S7qo5U4co2XjZEUX6Q1hy9YbYdc/Q+LKUz3grEHnA3QN/gie+/d5R5wBiBhO2AIJmZEc7CJMv1QPt2JNpN9CQzIjtUjAUi0hkUN2hR05X98geVv+qCrWw6qG/X3dmV1KLkX5lVTNO1GgjXhwh0BCJLwsqKFTbBId4vbuXQUYS4QW9y8SPZHoI/VmOVt5WNOOF3/NzEvp8e2WKWM7VSO/HvxLjMnCby7XCmspMnZ4/GtuVo8Hp0xz50si9egCAdlyS/cixQ70aEYAbaiTwjKrAtXV70jEr3LzZnYe9386ufXqdWJm+nkSlm7pDfJPQppfs0TMQzLPnhOAJzZDdwRuGXJ0kJyH9DpdDOaUSX5VlUQkSfqKeUQjvRhJEVoi7PuYTOJg3XuXPHeaaXD6iubmMHzLENQJY6g0Pqil0dVPvCycmBjfBLUwEtmlBd76QvRDlece6fT2jlf4Sa72s6xNTniepTigkWvxhSNUc/2d132ijHxQS9zOa/87mwc23I2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(956004)(5660300002)(26005)(36916002)(52116002)(7696005)(55016002)(66556008)(8676002)(83380400001)(66476007)(6916009)(38100700002)(8936002)(4326008)(54906003)(38350700002)(316002)(508600001)(4744005)(2906002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VLxZsqocWtBX64E3ZVwdNBewo19VcW02uPY3PFwGF3WaATPunuEcY49Z20dH?=
 =?us-ascii?Q?wCyJyVS+3Qvbq/eueqsPMYCsayJvKySw0YXC7sqYGR1fKkO+p2Na415PIN/v?=
 =?us-ascii?Q?UnD6N0M+uRXnBQ7/ki52DrIm6VsWhbw85fWllWuU0Ua1DeXnXDYp0z8ZaFhy?=
 =?us-ascii?Q?VQ6HSUXEPK88Vw0H6XmSjPJrZOIWkev0WfHnaJOCzQm5890OcR+yDnbhLiNz?=
 =?us-ascii?Q?CCz6/zS3X8Dc4qvNW/sKKHxQCHftnfQOuDo6IadnmIfLqQ5a6XWCVjUzfPuC?=
 =?us-ascii?Q?mas09JgyFge7Nia32OfoEf6P990uti6iJDTiUUXgRAV31t8mnSsKDkFIxiy1?=
 =?us-ascii?Q?wgs6Vq6ZEIWDCVrZPpgYPGeyiS4HRUb5rKpI0Y7q+707w7fVhFJ9YQfne+6q?=
 =?us-ascii?Q?3dpKzym9mWk4XB6BREDcb6EEa2pen556MVS3VmagiaG0a2HWINOqZVLlsdbG?=
 =?us-ascii?Q?fNIVl2l5YSq7IIu6X3QDDnrt+w/G5Ud5sOGQqt2mw6DNuf24r5VRUvgm5+9U?=
 =?us-ascii?Q?w6fM4ba7qK1rqX5sgyvnBsewr4bismfRAFqWJ7d9ZuPqIWbNjtEAK1ZOqFDI?=
 =?us-ascii?Q?DWyyqM8zxavf2VdRWQLubqprG76O7rRve3OhdVGBbfEY6+wyaSj2dxi/ecco?=
 =?us-ascii?Q?oeEJlqsr777Oa/lXMYtpLDNsgqMHZmzG5c+WPF4ONxUrvOpaZHTxJg5GBmUi?=
 =?us-ascii?Q?+niYZHOvjjc3n3DP7KLPHnSLZvukPzHcrvAYmuk/3SGHNHafUB4ODdY7kN4n?=
 =?us-ascii?Q?naIhzGv2pT0en1xOuQE7EK6pe8mSOeKZGnYllQXlpG2p48x6IP36a2sG8lA3?=
 =?us-ascii?Q?QczKycXCgM3L0p+gKqbNGVtpsQCagY5k+wnwumbK3bCftBhVYFn6H6Vym1cR?=
 =?us-ascii?Q?L7twdTzxHpRxaTh7fFHm884ogs3TxkvaI1koaIaotINBVp7KQ6pg/8bMNhVJ?=
 =?us-ascii?Q?RzXL+dQvaTX8VTFH4o3UG7xTG7BhKH6m9Xq77Kk+cD1gbWvDBw4V5nwij1XC?=
 =?us-ascii?Q?exqiDRv0WKE3IvNtLwFQvJH7+IA8ZqvkXf9EQw8+SMi6CYG2AU0cwRoOrV+Y?=
 =?us-ascii?Q?67teXE7v/kRNFMNSzcYTyx+AJfx5IqKFMsehCqbNFFSPmSFVD73wreTFjk+7?=
 =?us-ascii?Q?GpapW0v0Rfgw+jsOhRcZmCnsS9YOmjs9hfpaaA0jo0JQrlLc5lzZNxr59eFw?=
 =?us-ascii?Q?900wCoBgkivGU3iY3UYAvncYBcw5QD59IUkc6QUpVGVKzd/7bVkts8BWrbFL?=
 =?us-ascii?Q?U37w6xuINp7U1PhYNw/BkJxpjtgmL0N0nYSwUNZCdUzX7RpyqwG6JYthv9c4?=
 =?us-ascii?Q?Ul+uGRUTiQDyyDEG72WlQIae3XIj4no6qdhG4vlP0rifqANYpkcRplQweaS5?=
 =?us-ascii?Q?+VlshGGN00dmxOXq4erf8roFKrPFd3wXk5YEOi4uM3wOMWOnDvpEZ8Z0MYqq?=
 =?us-ascii?Q?WMBK9J2MvAzUmDkCwnUOEKCDE30m+lrP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3864ba29-4270-474e-87b2-08d99441efd1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 03:21:57.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: martin.petersen@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210012
X-Proofpoint-GUID: cobXhyh1bPLOb1hZhdenK1kmlNTHqkN7
X-Proofpoint-ORIG-GUID: cobXhyh1bPLOb1hZhdenK1kmlNTHqkN7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Konstantin,

> According to SBC-3 4.7.3.6 this sense reason shall be used in situations
> where thin provisioned logical unit cannot satisfy the write request due
> to the lack of free blocks.

> +	[TCM_SPACE_ALLOCATION_FAILED] = {
> +		.key = DATA_PROTECT,
> +		.asc = 0x27,
> +		.ascq = 0x07, /* SPACE ALLOCATION FAILED WRITE PROTECT */
> +	},

How do we know this is a permanent condition and not a temporary space
exhaustion?

-- 
Martin K. Petersen	Oracle Linux Engineering
