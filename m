Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFC3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiDGCVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiDGCVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:21:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DC4123BDA
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 19:19:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236LsrKN004892;
        Thu, 7 Apr 2022 02:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cHjsLXUOq4qYLORwb/obW8IxaqNs4O4HyiCcOcAmg5I=;
 b=qI//YRoiXdFF11CSufmEOHE/MGvaYy8ZZeTa/OPVb3lzQLckrjiMN0dfpj0JTitBgCTa
 9W/VQ+6AI8rKhyLjCKcPnemgCsuzLhWLMe4YwBVHwuGg2IzgePQ4+i/JYIMYpBbgX9go
 DobaZt7U/ypOea7NVB8YstJVJaWNix50kIYCFavMihCUttuVTKJQdTbMQtND03qnU4N+
 N9m6oAF6s2apSCYVLM8hLbXjQhGRnn8Yp0JD9SBEDqLyJQ/fOQHYTYCOuIGy2syDQBA9
 yVwfTqGzSCuIk7PwULyi3t0NF+h1no41wTKv3h/YhzH5HevmPSk1czZQH5kqN1pvJp1P Pg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d932jnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:19:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2372GQd1026814;
        Thu, 7 Apr 2022 02:19:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f97wqrt1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:19:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noJ8qqAM5F9Ao8u7syr4v3KRby5BLO8EwIHx/z0ZfL0LwxTu9HH1zR9Jb1jKXjZyLBIYoFkirstokgZgPc2/YcW99kR/7KQFEVGJn5UTzW28KivOqmTdxblDGmqVqgf7ct6yBxYtdkZoWD/85Yl+I50yK6XHa28mBppkHpyl3uxx5w958Pf8xXfK0To2ZIO1YF8r1d/AMy7rSPBU0Mad8+/CeNlmrewTTBlF1FYsM2F4JvLhjqDNGmQMQvODm123SFHrv4e9zSvsEMexoNh00b91jdK7OQ6sF7RKajpj4clgf7kTYVX1VgJgbAHxLu1EruSDVnYB7v/TDLcO7v2s2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHjsLXUOq4qYLORwb/obW8IxaqNs4O4HyiCcOcAmg5I=;
 b=cCkp/BF5zH4W+vBW5Csg+PyjnQIbo9ILN+wJKIuOWB1Me1JSXfQlcjmH2pQrs4mDrFDnLhqUiAYWWdT4A24TwSsAGalGH0uuE96D+LTODVH7DMLozH5M5OdUigljQHLGuBOqKidIVMJiAdAbgmYzZem1T+rwnP4o7l1PaPglp0Up5ry+WtBuwlimamTjoZK0zSRRk0NdzVsxrxx3lDmlBwGrX692UAsuVuGGmryGlUOt5mwcuwqtB4ScRu0dRcXxBASuQyYfzEQHF6Zx1qbFwvMVXFyizY9jaibTI/pvZ+++vrvGk8Ogv6BpL28vxTNsKk6ui+I0CrFjax8zrbvGEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHjsLXUOq4qYLORwb/obW8IxaqNs4O4HyiCcOcAmg5I=;
 b=FkmCqRw1ZA/vOLXiCPvpNIqDgfK4bg8qDZEPEP3pmNkgIFma8QC5uowoEaS81KG4W1xabFZOc2tis7CEKcav4hMBXr0BhnS+lp+NYTC1keOkHWVjf00zmt5EhzukjPTYJsfl3QrV0S8/S5NxhQ3yMLadJes0Z5HcKUkqkXIWFJs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 02:19:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 02:19:35 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8vlljrf.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-13-martin.petersen@oracle.com>
        <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
        <45050814-f512-f764-007f-5fe52e224467@opensource.wdc.com>
Date:   Wed, 06 Apr 2022 22:19:32 -0400
In-Reply-To: <45050814-f512-f764-007f-5fe52e224467@opensource.wdc.com> (Damien
        Le Moal's message of "Wed, 6 Apr 2022 10:29:51 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:8:2f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99b93670-0964-4822-8127-08da183d0f23
X-MS-TrafficTypeDiagnostic: SA2PR10MB4811:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4811B3F9AD2990694143C11F8EE69@SA2PR10MB4811.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vt5Nl3eO1QtIcHYDzgVVQ4g+Dw+NmSzSQgmOMncRbAml5CZILfPFKEaWpSXW6rvZQRNb+UBYrn2coaMmOQJ7angVPHWzVGH1HTEiITAvAOC3m623wFEvnHzKmjLnhqSq8I2Z1v3NwJpnjHF4CUzf8X77lOJwsTqQ1IbhVP8QuSp3/1AgdzjIfpLweudrYpApm0jsOAqS6t6z8Ox5tSApqllTpzt/vyfN+iFIka7SkGUVeg5YXAIdZu6tBt9ExLYaGo8Y1JA9GNA7X77ahgqxchySQGZWC9ctbgJDhHCbjVZWHwIlY7Ut885v6gWxGNdWXIXrqszAjjKicbzRe/weVk6vC9d71+WgETcbil44hWupTkbSvo7DA+z0z2gJ54Dbq+Y7Rm+xJ8wS2fvid0/98XXdBRKLonF6PlPOb1EwrbxHNBK2trbYXkWTzXMMX9+4geWxw4OKRa17fBmDgwk8IcNjcIwZTQJMzaTRtxj8ixpZIt+ze1LSBk1QLUFzYrsLvJme6TwMeda8upsbXwdoaCQA4CMEN8WrKe6cXWE/XszhYYX7yvsuvEqkNAFMLLvZIj77rRLWsMiN0XNY0f1pffj9zCxKIyHX/7UOQSnajN1GqsWUlaPvS6DXStA4L7O4saVz+53UXh7aLrianvdhstgfvnCrRx4FjuhxnhngRwK8kQYNfSs/o6vS1E0ZQ4VbXICT0BEZs88jYzYZ7cRw5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6916009)(36916002)(6666004)(6512007)(6506007)(5660300002)(38350700002)(54906003)(38100700002)(558084003)(26005)(8936002)(52116002)(186003)(86362001)(66556008)(8676002)(66476007)(66946007)(2906002)(6486002)(508600001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lyTYP5XzyjtQCdvqIZ+8X95HiJnPgl0oJ7zJ/kxNXmfmRblf4XCW41pyK8yj?=
 =?us-ascii?Q?p6zu0i0KAr9I+2mbgBumNCw6kzdQYbAtAl9daTiXGK1xdeD1gPacc1wcO5ML?=
 =?us-ascii?Q?HlqIA9aHpmLvTApkRdK7g910dg0BtyNnNc9qmZ4eU/rYgUC9goKzbo5RT7Kh?=
 =?us-ascii?Q?XtpvC17TYZSUwPiXfPqycKRb6whqYSPnG7Rhzq+lBTZdnSWXgS5R/kde6KmE?=
 =?us-ascii?Q?MTRCTBHdFs93wo1bi16NfXs2N+3TT+Xr3j/xk7NLGC5vv/V4RPSKz31o4Cdp?=
 =?us-ascii?Q?uHGubx51PyvOd/dNrQiErK9qAyjUiFQl+iAgJyb++5JXaT+iuwHwvhtOaaeW?=
 =?us-ascii?Q?PKLduWgtqMq07ETnmFdPCuhur4EguLOUsGuPL5stez0qhWO+hBDV4SHViqVt?=
 =?us-ascii?Q?2WngsSoQ7rVQvZSGJJacRFBmHgLdBgjwq7UeHp1tWOXuriww4EzVuD6qube9?=
 =?us-ascii?Q?+tm3d3tShU/hsiyMnOEexlFdZ81+xe/LAD5XsJN8sXizmK7YUq2EvKokbzGG?=
 =?us-ascii?Q?I+DhL9bpzi+kCdlkpnxgST8S2FpQoa8pK3szDFi2VgUKUAa8q61ej5fh9D9t?=
 =?us-ascii?Q?8uZtE5PDTrIpbJOUfOvN1iODYX0TRBIcUFyY0g+buVoqSwjhL82WdmMnbLR8?=
 =?us-ascii?Q?ES7q6qZHw9KbPk2c6WmG6U+TLSWWJP8pwbDizJWiVCGprFOqVAI8gtTDfxCX?=
 =?us-ascii?Q?1IPokz2BttqaRh6WQLyXKBNIMgN7pF0VfgKoFNLrMU1nzV5+EwbgzlVhxzTo?=
 =?us-ascii?Q?jnHidDBFG3f12ghKLd/cj+zbcLWOtANfHBWWJfYU9Rk3chWYn3iDMZ9l6Tw/?=
 =?us-ascii?Q?z3fqVe2Q+ZQQSKyAStf+MiD3nlt/e+NZWXkevnjrvmLBmVYyZrRjsVy3uHF8?=
 =?us-ascii?Q?2kNwUThUTNzb9w0MXY3XjhOAQtgQG1KiED03LMlOdrmiEiwYCVGeMDWtfv0m?=
 =?us-ascii?Q?tZLaANMb7OdFqeoLwgslZz5/5kcxdPBD1ogTJDkzWEF3vCE0IezsrNLmLa9N?=
 =?us-ascii?Q?62APC3KwDU5zaOMRIA3HwLYgRJ0zGzAKXiiql7tsY1IhlfoYO0GO2Fo8hqXI?=
 =?us-ascii?Q?H56I9ljiI3+WZstITTcsYEWAdXUTirh+ZjzS13yK+eaLJ1oBl+7kDzJbuSYI?=
 =?us-ascii?Q?/ZdVLOC7S3pkEGIhlWEqUdcjcQu7rg8xs3mk6PdGlLD1qQgXaMF6egTLDO0/?=
 =?us-ascii?Q?x9dk0/a7Tt0O3uZ8cTiW08ZXiGX21AC72REcWQZxy5acrupVdQW9aHJOWSzu?=
 =?us-ascii?Q?xNGMOEF08Cn7IA3Kw1mr5r/pqs+VUFUyhQP25dnU+oDz8U37Bv5Q/AJTH3VA?=
 =?us-ascii?Q?+keeBvroGOI4xEqDDJ1xJ7Yg6+oy61oxEKXLTcXjlZmFyN3vWdBY+OaHWQmQ?=
 =?us-ascii?Q?AvEhvu2i8rZIzjapUJ/RXUU7L322hmtfxqiELrq9uUcXWi7pidsUh+djgA+0?=
 =?us-ascii?Q?ojJ3xjzOTsRpblGnOQ54/w0gKRbDqGxYSAhOy3wSPfT8YR/MkRGF3YzS9aU+?=
 =?us-ascii?Q?lovhO/+/YL5eLq5LhROWZel48Chf9CGhXVbvgoPEDbeCXGrH7YGP3F3SK3Wc?=
 =?us-ascii?Q?X6swB8Of9r7AWKD9J3fJS/MHWhzWHfCPm85cfGbzgz0kEx4fCArLnUtAeQmv?=
 =?us-ascii?Q?wDudDzVkMc++GHHEH2s93Z1EIIoGNSZFaz5XT56kz++qz/3RfEofKbwr3Zyh?=
 =?us-ascii?Q?nPPLpEU/CubJcaxlbCRd8hNP7ZXlDdezO5V0XY+zsCgT1mogWh0nSFkKBMN1?=
 =?us-ascii?Q?qeZeIWmskBCc3w5MnmaLNTBxbDAuMa0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b93670-0964-4822-8127-08da183d0f23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 02:19:35.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvYx8SAjWwp+J5URABIGLZG1qItUEFGrggIemUsxvwBZjzrNi/bQ48yHHQeqEh4Nm8pJofhI9CfiAEjMVu+eofum5XszPX3Kwy6hQf60y+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=982 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070011
X-Proofpoint-ORIG-GUID: qN3MH5sGoWSgO9fzXtcnH40nJ0TmQXP_
X-Proofpoint-GUID: qN3MH5sGoWSgO9fzXtcnH40nJ0TmQXP_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> I still do not see this patch in 5.18-rc1... Did it fell through the
> cracks ? It also needs cc stable...

It was part of my discovery series which I ended up holding back from
5.18 due to a regression. But I'll apply this particular fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
