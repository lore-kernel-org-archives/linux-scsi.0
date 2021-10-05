Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28262C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEBE610A2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhJEEia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:38:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26496 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhJEEi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:38:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1954CFCs004524;
        Tue, 5 Oct 2021 04:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tiqqNDIgY5hfJFod1zvqkcoL4rYe1dklbpjPeCknlT4=;
 b=UXL1iYYgTIH1ZjDlr6bwMSyiSeQnL1WkfMfWJ0Un2gobnPOg2nn0g394bId/PIRz+lSH
 ncZfUVfMKUSmRK+LgE6RFTwn5OhyjZXRar0qJvFHDQVEyO3h3zu4RwlM3BZPNxMJhjQy
 /c4FnpCZnyzGBUPYodBNANBIaczxQ46IB6ukaUBVsgD4aWUq+TQJdzxiYLzHPNYUvyWZ
 fYIROxOJhju9aNcBB1x8FeukUJ2xy3EWdqvQG0R0u71wirI9/2j6e+yCz+jp4ysN5csb
 7AVNrBXGig/D7lB1B1h/BEDA2sK+H7k+iv/5Xk3hA2gYdZzSrjXN3XeIy2Gs9o0dEA+b HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43dv8jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMc054346;
        Tue, 5 Oct 2021 04:34:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zz7O0Kp4DGUSrurYgVF08keEWvFxuYSBbzJmx3qtCfjg/NwEgpB6ZRIedb3gmP/30OSuRVOjP44qAw9ixLfwWkgZlqlADjsfhVP/8VkOIWbRwehnp1qwv9MgeRPlf/G+Tyy546rZBBDYr2O5QKJ1NTD9fG/svW+vpwox+2+rqfHIwiGjMsyNQqyxKfOasXO6qkQmQmAafL2UB2e13spdNzwy+bndxvVFTuiCYXDc4GwVok/agiHh2IHqJkHPLgIuc57boX2MpdRkf3Xye9J0ICeMqHQruMyitGpIkaCbl+y1qGiCWnxLPAjz8EsOHxzbAF20va5oF9JOhArZjJDrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiqqNDIgY5hfJFod1zvqkcoL4rYe1dklbpjPeCknlT4=;
 b=YCyEQk1ru8eDJ4X1oFKes+zwKCPpuJKZ+qqPqhjGyH49l4Lm1c4H9UqYrlgP5FCsveOnPRwm1vrDI2IywNL3KHJWYyMngjFo+Wxe7jVQHD1TjtQfM7EX/E3yDynoTcZj7MpmBEH0UJ0nyFkLNwbut/2oky+UPyK+wO/ATD1CksmVw/Wu+dDDzIYgxgoLtPgmsjStk0i5xCmc9AFLMHMfUrmN424no15n9rwei07XdU1aVWKJd3Oz4huzoie0GvOHqxcj37tOEWe2CZrN0Qak7JAm4kcSlkOfRyXa0LfDJWj6bk96QlkScMi9QNlemkQai4ZklLCoIyKpZWjhcHYZKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiqqNDIgY5hfJFod1zvqkcoL4rYe1dklbpjPeCknlT4=;
 b=VC3BTckXrvjimto1ct3iFaMuR2ZGuWOHHMqMtRN2Reboi94aeUbqSd6M618nKEsnYnn0Tc6MoZExTBw9YOTU6GqF25mqGyERv6znzIY+7QxwjcNiu2V67+xM0gV8SMcTFnV+ylqUs+VRx/OER+1WtGLnEfKtiX3KbhGxlOzXOQw=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:52 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, chenxiang66@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: Delete scsi_{get,free}_host_dev()
Date:   Tue,  5 Oct 2021 00:34:35 -0400
Message-Id: <163340840531.12126.7318182624086040628.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1631528047-30150-1-git-send-email-john.garry@huawei.com>
References: <1631528047-30150-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6479f261-9c5e-4ea5-3136-08d987b97905
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950D222A279B2EABC4A1E9A8EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:275;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t32oO2y7MNOP3PcDTEWzLjqHad/EQJRln74VFt0fs7z+Qt5n6nFKBYqr5HTnXnKKtmH3vw3COvLZ0vosSZlnlrET9Joi3uP65cJGCIFBIB+x8xVxDVxnFEwXeFh1UKb+MB+LZMlkuwjGNvj6/x7LZWG0rtL3D8OlliEbwTBOJsVO8TjC+r9w7grkYO36AYAbuCeGgLT0ys6eoidkJzb4PO0cjaUv1DpK00VWGPJze7ksPjWCiZZH/k7qr0i4QeN/vzW0CD9ySMKYEsiC4s11bnXsuCySsudAnqawQmwBRWToO/QDkOBcAyBirhwe0go+sL4u+rNn1z+seq40SSWr0kvUn307ja6f8spTLJHNXtRJEM+sf11cJUtIuOG41CV+TKVACr6SDr5/zme6rQ2TTs3pLk+SxNjVtP+vtXknC0YAdJyj1HNNiWeGCyQXo/vlwjrifUHFmuHEo/qnhMe4dMvuBP4zENyE/ahf7silaI/A1lY48i1JJwN3VTgyEMMdaY+YIg1Ed0wkjaCm2YsqAYF0VCq/Pi2O8vV4ntvPrbTyKQ14ehgzcDna3X857wQjqPpSwE9Ps0D0/c3LroihRkApBlajPZPxuCM33ro2BRXCCsjffFgZu58MJZH9H1B4IoW+MVODiX6bKzdhroG3m3wL84IfshN7Ali+bnhKgGuTkF0VrcLhIf2BU4HT3xgPvR+NMgJY7M7zdBl9ThRzDr3VxTNY5f7NC3vhFgTPgAIhE52yAh4BRxI4nMw+yjwLWzSuKGxBh0o26WDFqaNaNrmevwJt32Y3FhaxNDHqEV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(83380400001)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHRtTUF1MEJVR3hBRGhJcG4rU2ljT0dnU0NWSDVxdDhwM2RoZmtvaTF4V0Jh?=
 =?utf-8?B?Z0UyMmlvclhrRU1JNXpVR1l0NmxtS2t2NVY5UTd0azEvMUFock9wWHpnWG1N?=
 =?utf-8?B?aFpSYjUzU0tBeWQ2QW5lRlpVU25sSmJCVmlpN0xYaGU1K3RLelk4aUh5bVAx?=
 =?utf-8?B?L1B3Z0xveUxOdm5VNkNzMGFEZjJ4K05pWnNuN1ljWGYrb3YwNlE2Y1pnazBL?=
 =?utf-8?B?dXE0MlR1Mi9aZEcyY3J0VE1XMnh6MHI0K0UrY0diNmpkQWY5ZVJXaThzNUpt?=
 =?utf-8?B?ZGRieTNRcmhXRTVockJkdWRvUGQ0YUVYV040ZEdoaEhKbE1TeStQa0NyMklT?=
 =?utf-8?B?b1drb1F5dGZ3YjdrMlR2TDIvYnU0dUM1c25TSk1iV3F6UC9oTDlDcGR5YmZt?=
 =?utf-8?B?S2RpNzA5ZEtJeE5obFhIdzdFUDdQNG81aWk2c1hscXVMdVpVcXVIS0JHTjZN?=
 =?utf-8?B?T1VsNTEwTmFvUUZxazh2QjlDVWNZRGp1c2tvQjZpOC9QL2Y4NC9iMUpIb2d4?=
 =?utf-8?B?U25GcjRYZU9mQ1ZndHJNYUYvb0pKbDl0N0MzMU1zcEtWVlFFV1QrSXk0ZVdE?=
 =?utf-8?B?RUxIeitkM2EyNW5kV3RWY2NmQWtQY2NvNVhhZGZRbXp1OHdScUtMQlh5REZx?=
 =?utf-8?B?RW51ejZxRktIeCt1d01mL1V4a0lKSWpnY0UyTGVDeHlBdmRiY1k0N3Y5TXNZ?=
 =?utf-8?B?anlpWHlTNCtLbEkwenZ0MEZZVUVDcWNoKzhPNlp4d2h6REVkR09odTVqeDNp?=
 =?utf-8?B?ZVJrVXFUTmY3Y0RXUnEwNmEvSk1Ea1ZFdllweWorL0NCaDNxU0hrS3pYMFl6?=
 =?utf-8?B?T2lHbnBhbmxLWnU0T1YwV1hpamlKWlpQcGRpZ2x5aWJLZXM5RnNMeUxCWk53?=
 =?utf-8?B?ZktNcFlSbERuZDlJeXo1KzZuUDIxOEJRWnl3aHNsaWdlK2NTbjBadi9HVFFD?=
 =?utf-8?B?RkRyK1h0YlVuQU5UZWlFTWFsZXFSZm9IOFI3Rnc0bGNMOHd5MHY2Z0JwVEFB?=
 =?utf-8?B?QXJXTkJwdVgwUjcybzRSUFZCZ0ZhL0Exak5MWU84VGxMRmRBVnVwK2VPdzA2?=
 =?utf-8?B?MXA2ZUFSR1JFYUdLa2NiWm9qSDUrZTFBZm9tbDFycTFZb09XRlNWemRsOHUy?=
 =?utf-8?B?WFgzbEdDVTBkUkdzaDdBd1NrUG9sTmxUdDFYWXRpRzVCQ3V3cVZScG5iQ2hE?=
 =?utf-8?B?a0F4cjBWMncwWjNQakxWSCsvTVl4L0dnMEt2VHVydjQvMGRiaEFMaVRLRWNa?=
 =?utf-8?B?WE1tMHVqYytYbHJVOWIxUldhQXZBMzJ4dFNBdFJuR3o0aGFoM2ZDTWhVRjgz?=
 =?utf-8?B?WlppV0w3dURMeVVRQllheXI5a0JCUzM2ZGR3aUVSTURlQmRMM2lUZ1NnaWRE?=
 =?utf-8?B?b3k5T1hicjdkLy9UdEtHNXloUG1mSlhCeFlHS2lqcXlPNFpmU3FiYTJ1cjNt?=
 =?utf-8?B?U3ViRmtBeWNGb2xsUTdNR1FWcjlTN1NRYWJuM1E3QTNScUFBaUlvc2dkZ01Q?=
 =?utf-8?B?c2oydEs1MTBGaGxZS1NlMEhlTk1iM01QbTh5aEdUMmNtOFZEVm1UWFFUSjUx?=
 =?utf-8?B?SmRoRmc2bkQ3MTVoSGh0T0YvS3BoSWMrNi9meGJ3NEt3Z3QxQ1doVmZ5ekw2?=
 =?utf-8?B?dllBakt4NGpNVGFmMjY1dVhrVmhjY25BWUN0azNNSzdGR2dIbWtVb0tkdzAw?=
 =?utf-8?B?Y0ZmVFIxNW9aM05Cc0c3b2oza2FCaDd3STZTN082S2NLMWdNM1VsOGVTQkJP?=
 =?utf-8?Q?5g5DGhOsdPcv2CC42zHGjD53fH72TSFPN8StkPg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6479f261-9c5e-4ea5-3136-08d987b97905
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:52.0769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksl57dUtCOxdVST5ODVNYGlMU400RYKhtpLBE8DXn7kHd6M+Tl94JJCb6xccBt14ohnVC8GVoihrUOLCkrry8JOP0CJnFSIVkueiEagaASc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: k23iN_HFSn3N7FbBYWB6_19pHS1IaIA-
X-Proofpoint-ORIG-GUID: k23iN_HFSn3N7FbBYWB6_19pHS1IaIA-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Sep 2021 18:14:07 +0800, John Garry wrote:

> Since commit 0653c358d2dc ("scsi: Drop gdth driver"), functions
> scsi_{get,free}_host_dev() no longer have any in-tree users, so delete
> them.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: Delete scsi_{get,free}_host_dev()
      https://git.kernel.org/mkp/scsi/c/6bd49b1a8d43

-- 
Martin K. Petersen	Oracle Linux Engineering
