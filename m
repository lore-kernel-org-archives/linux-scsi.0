Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428C9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15BB961AF0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhKSCxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:53:14 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11562 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhKSCxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:53:13 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1aRSL020979;
        Fri, 19 Nov 2021 02:50:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=KKqHHkiijZqmDr8z/sG8Q8KrC5xzz6BiS+K1Q8Z983g=;
 b=WiYfVmc/bOiVaVrDZXMoXaxv8zm1QQrxnI6alr+Hdfp7qNOVOAkzItXDQYbUnurTDew6
 TBjNFD1312a5Cyxc9YUQLJL3loBTxFuO6eT9+olzRATkBgvLUzGZS8J4HIl+oExZq2dp
 9+FYOb64w564o8Ym5/xYd+xvQZEYvF7sblSy+660MqPn4sNZr0qMgzJrhEbhahfIci8S
 E1ctb7LTu3rpg80tl3tWERKnaWKXWw4b5tX/s7UpUQMUojY8LavsLJaDVAOctxwnrdYl
 g/uv+5dc8vRGIu0KoY5YEb4nMkE76x9n95FKaNHfZkleEY2fBLaKO6vqWor3jopfIt/5 Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyu4d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:50:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2knW0017992;
        Fri, 19 Nov 2021 02:50:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 3ca569kdpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:50:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVGBwHmdFvL5Q8s6iNzZzLvuBAqZunmM9RGsfSf7aBvYid09S04hjANzNaFRWEVv74qGQ/IscqnlHlZxSTTp9qkH6YWsYlTSkXECkMlz0zFScnePW7+4eqNe42LfjQjGFAyruXBqK5bdFJqI1tuQB8F/IPY5o0PZtwbXu2FupLJ3Gsof93DkSKQZ1HrqSpxe4puS+9iKwoHDBuc2+a+QGYPphKW1dPkMfLeUt8Wg+LolQLy9QZAEc7GJYpJokN0AvL/ThxWKrRK92KWpLaW4TvIOWGewKdIYkkY4SvcEFEZlSobpeWtdNCJo6kRITXjr5dpK7dOsoq1LVWwu9xcuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKqHHkiijZqmDr8z/sG8Q8KrC5xzz6BiS+K1Q8Z983g=;
 b=OccGvh0LRDA5kYXptc9Ykp/Prue7UCg6r81r9wU2AGwEAgJWCiNPdenhWNOkGuo+ifwqOuvIbUgefsYOTcurJB7B7GnTERtVz+1qzlrmMS1aLnOCDmMvGqX4+On9YeKKk2hZr6GGQw2nEX3V6Q758CsW5RJpjDO1hTbvOJIFBIkG7MTU0xvmVJSLqGR3P/jRET0eGXAHzhkDqNA34thI2fjcywNk8POwodo5TsXtHmn2/eaf6Tn0DYOjqlDU1MF6U/jrJk0WbdkEmDPKCEfbIHLFIMFfvYgPriR776sCznA6rP6BFlPpaclSsjQ2Wrq1qwJo+O5QLAIirQby8hPZWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKqHHkiijZqmDr8z/sG8Q8KrC5xzz6BiS+K1Q8Z983g=;
 b=cAh0M4d15ZbbQyxtfo5J2GeGQ3r/EkoZlvmkWPUM9qohyPhXfvT62roKKim6H/PSIX4zSKqVUJPgwl5TDZnJeZ2R33WtE7lRXaNAJHHT5QCaz4Mb3Pww8Dv70lewAFdLwl45jLskXsq1Ef7ToyOR5+LHlpSPyKeDv0389aZHXzo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 02:50:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 02:50:05 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] small pm80xx cleanups and fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf1k7tbh.fsf@ca-mkp.ca.oracle.com>
References: <20211101232825.2350233-1-ipylypiv@google.com>
Date:   Thu, 18 Nov 2021 21:50:02 -0500
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Mon, 1 Nov 2021 16:28:21 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0010.namprd06.prod.outlook.com
 (2603:10b6:803:2f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SN4PR0601CA0010.namprd06.prod.outlook.com (2603:10b6:803:2f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 02:50:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40034d12-de8b-4ecb-8332-08d9ab074a46
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44692F3CF1B5A620AFE92C608E9C9@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXd4O4GHZOi1wjvh4CfK/wm/fnkAz5fYpuVO8Hls9uE8wQNIJrOcFyvHfDkS8XbqSoKXD5YdPgGXbCo9yN+eYNIxx2YYOIbqrz1CsWBbYnTrQ65NTXkMT/skOYbMzVJVlzuNPxlWckDQhFPkwPuJ0V4hpcuM1ySttdiX40xFGQgkU1B1DrKy/RtEs43Pckm08qC3vA29k+W7ZX2gnzyi2Ut4ITZOGHOy4tcaqrT9CAgJlyYgHoddse5W0NyPkLm67fk+UDtsjvVWD12W6DVqkKq6rDMv/UQTLV29fjUsAnEphd1ZCCChRu0Hvc6eD0gHYxxa6DI6dL58Pt2+yCBboyRHQGS3MEJ/oyvclNCcYbux12Am/pQhINGY3uEcxXdHM79IllHGH/tIYh/KSS3+TPDzpe5S3gPAKhcZJtkIgykveKx4GVIGXxLGeS2O54dw3esY5BNyFOoLbk0Vehc83PgBHMQ9TK1DH08rqSFmkdCwOS8tqahGTwiNYi6fmkSn4BpG17Guu/yXCcKW272aOUcoPqe9TWsv0b9zekNS758eYADse3kwYHflFob4MMflGHsSmay/LdXuysO9EMlgo9/C0vwLk7EpITzPI6mcNtsPcvMNXB3AqEYdOjEMKITWo6X6KS5DLaytM9solvBPsSayQx6crw7z6eQqMA1xpjeLHvrqBQpCmEsR6gq+Mdldh5bIZ2ncDPWkSAWwFaL9jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(6916009)(4326008)(52116002)(508600001)(66946007)(26005)(66476007)(66556008)(956004)(38100700002)(38350700002)(8676002)(316002)(36916002)(86362001)(54906003)(83380400001)(2906002)(55016002)(5660300002)(7696005)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/7m2Qah3rHV1zw+kTFwQ2bOKEAlSBwVSWFbWasii70D9zHiSfzaOzgxLr9y?=
 =?us-ascii?Q?twpATuDBhrcdfldDmSYMW7QUwv5JuYRp8Pkd9EoypLWI7zUDaO54beYY/H29?=
 =?us-ascii?Q?AadgaU2+ENZ+yu1zhI/biZnlz0Q0N7Px8nja/xJk2AXkG6xiLulv0KgUbTuX?=
 =?us-ascii?Q?wRnzSEbjkpVe6Lu+qy5Hugx2+xYebd/QrHOz6kPRktUzN2j3cwRgq4rxcM0K?=
 =?us-ascii?Q?Skl+uTSnyG00OG1ilwI5vvmNj17QoFOUipdGjBJ4zQQQ2o0UGXrPYpr5Z2c+?=
 =?us-ascii?Q?uLd1KNgHMr2TlOefCYrogQfYuN2lpiqocpTtulTjXUwza2v5fDKPGCWhZd/i?=
 =?us-ascii?Q?ROtX5HVxKIwhA4JjiNjRhAoaHllBsonA6RECb0RI8GDuagJNJ0H9LoHO9Vx/?=
 =?us-ascii?Q?vD0qMOElYGZJE04PzZ3FuIyMBYTqEzXLf+vPxqqEm05ayXahiWnzrJAwFdbs?=
 =?us-ascii?Q?cFbG/BjgoiegnvwQB6q3T2KJaEkYwfEs09PDjXdXcI0ztE4UlaXuM9RbBPyQ?=
 =?us-ascii?Q?Ip+eoHjOM9itosEOR4lvwnkp2Qpf40y3HOucGnJLoEZpfmRAf8ajJqC7jwZ9?=
 =?us-ascii?Q?IhKZ0BkTRauCl29OIa1JnlqveWYYOTDGB7IB/leEe1Gg2J8z3jwe1N/dyyEU?=
 =?us-ascii?Q?nPzoCfl+H03+wZlXi4va3OqD1/LvB0MPgKp6ZNk2zSz3UbxLVNNtzSGjcgCq?=
 =?us-ascii?Q?2E4jgzxMXWZOJaEWvdp/bOZKkYZZwn9LVkcUfZBqPSP3oqWiAJuj3SPjqpKE?=
 =?us-ascii?Q?EyAL6iriJR+6ossffdReR0wyve6zU1aivJ5DIxBqz3kAEC0K22yB1puQBWVM?=
 =?us-ascii?Q?Aiu0nS81Wv8FECdK2oQmHb4eBxhVMLR99SWD0abF8REzk0HdSf/wS8giY+Sr?=
 =?us-ascii?Q?YOYcMAa5esaBZ078WfReyRwOqEkxhbrirU8OXPT/JzJt9LeJQ7wgc01OCPLn?=
 =?us-ascii?Q?M6hUHghYp4rUooe/uNAq4G8MboyVR7uq+BpXVsLcdlVU7RoFMw952+XUawV9?=
 =?us-ascii?Q?ebP7j1AiLr80KCTnNP43QwPWv4j2uf28wCtoslyU78KR7dWRAef2npnvjziZ?=
 =?us-ascii?Q?zpE7YHREEN4PpK8g9mzrh4FyPaHC5Fsd6O11I41AabWHORdW7ni7BEtiTTNq?=
 =?us-ascii?Q?WOpQRVpl9h78Q4GNsx01V4ipG7YOdsqtF8GYCQvFUUKGRrAo+O0lwZaWtuLj?=
 =?us-ascii?Q?fI5j0n6YFxSH6nLrOe5vCIet10Nns3yjvSfC5lQHKidOuo1ItdjsaB2uF2Ud?=
 =?us-ascii?Q?FhNDc0INsBihdoHwaPjVtj0SOBF4Yu85O205JgSxSDH+bVPVwwzxwP3xhWW+?=
 =?us-ascii?Q?vKhefXPQxK6ZaL/JNEUSVhLV7sHWq5SwcM5J56wIJ0lVvHeWKqcQKn1nPFAf?=
 =?us-ascii?Q?xIoIaxVAOzUGRX/7yIxe53DpVTC4X1AA+k2h4e2OA+4UVibZtuHq9VX3+Mta?=
 =?us-ascii?Q?rPTe+idUhhMPaHmnuj2IupyCa3UEnxXvwNfvpK8Oh46T9dsyIPZcnjSTqUUU?=
 =?us-ascii?Q?5DraFL3KJNAtvivJv9L0ff6fzR/ERtsBTpc2s9ttpZ1i8DY49ZU7rrSTXzk5?=
 =?us-ascii?Q?eWQrk4fhwDvr77oCbgEsSsJFX4rJMPLorcsGcd99lydnzwSWcI4ab88jM4G7?=
 =?us-ascii?Q?E17eZILkC//5tMAKH5Fvyuf3NVYifBj+BwGux/ka7n0IRPCtZenlwge+aGGb?=
 =?us-ascii?Q?ozP/kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40034d12-de8b-4ecb-8332-08d9ab074a46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:50:05.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5eftjf33e8NUK1wz9CEv8UmmcdBS2jj88BAUWgTJIdUbQgTvzMbsxuHmojOVseWofnoO26WEvy1FS86EUjmDlJl7NB3YdqfvsriGGeOARc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=941 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190011
X-Proofpoint-ORIG-GUID: q3bXE4tURJhYUKjhqHTiY5-laMDp2_dZ
X-Proofpoint-GUID: q3bXE4tURJhYUKjhqHTiY5-laMDp2_dZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> Igor Pylypiv (4):
>   scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
>   scsi: pm80xx: Do not check the address-of value for NULL
>   scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
>   scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
