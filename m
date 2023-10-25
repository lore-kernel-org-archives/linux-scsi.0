Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11862C07545
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjJYClQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjJYClO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:41:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D7F10C6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 19:41:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39P0jJj4029307;
        Wed, 25 Oct 2023 02:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=X9zqoYiZC0tHmcvod8kF+X6yGXeGchuWr4HJoRiAo4g=;
 b=W/WekpHdWHjFHsuI2hJi8u8q362sFZRBRn//8HN11JXc4KLqSd5TjurHQcrU44QPXWno
 4VXH91RXJFWQsl6zwZbVC3SaOj4D4WZrZbLsyDCkf3+pn0TRTqZvZGaAwCfKbC/ZFWO+
 Fw8Hw1vwdvB4zr8OzH6M4f5a+/7KXWqE9SK/oY/q5jJLsw8IoiW2WScPjn8x1FWw4ifl
 7YuNcXLsOq9L7EiScTDNQM7/13CmtHvDCj56ZcxXLeNQ96/ej1ASWyPzbFsoPqIu7ag4
 J/01721ppq9k3uBUB9tIfLkeh11GtNXXbz5F5rc4WlwiK/NdpEkAx6NWJ0X9E/VGZSEZ SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6happb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:41:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39P04SCR019037;
        Wed, 25 Oct 2023 02:41:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv536a9rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:41:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEnVZB3x9ITA1N/wGUvHozaFMhlU0KY0L1P08Ytmf8/l/ZoisUvh/C7cu4sgclUogeSpX5fhOi9XnvRoFII25IKbhpqbL2L3Q9sm7Nh2xZ/+hsSlsYc+UNs7LVOJWnuCdGT3cQIZQRkkEqC8cAmQ2Z8WI7Wd5Aa0Aje1yLEE1iaXyyU8jnCI2xLpH169tC+MXzS04XVSNY15BtPqxQYcXTGjHYAL1Ehh+AQc1ubQ7tufzcJa2L8pLYSD01YtRyHwTfYmS9hGcEFTPnFrLkaFVnjPGR+5fpjO98HDeCmF3iBNm/haL1gFDRZDDSj9Q27K5WkTBuO1LVmfk0DDZe6clg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9zqoYiZC0tHmcvod8kF+X6yGXeGchuWr4HJoRiAo4g=;
 b=c14FXPoUHx40xLu1fyxwLUjrIzAG/OdHCJbE6rWmnOygrTOQnQGpk0AaE0OlD3dUDKb9B0D8+069QgV6UBnqOWF09RL+LMPkNNpmSuAeIcqtnIpimxYHZ0PwXus934GVGbbGp/hQzQdbM4C1CzcnOOSqdwLrIrY9ETw1X1iaI4tHvRMpzG+HDqWeNIu09nrjNeV6qi1xh2CZDiABM83B1Tc8QyIvmtOvC366D33WpjWx+QMBq9HQAiSo1XaosC2+GdDPGvFsv3aNltvJlobYho/ORV2bIWofWQOeAWB3+rgHwkUGRt1sBBYFZoU1RNcTYGWJri4JDunu+PZoXsvvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9zqoYiZC0tHmcvod8kF+X6yGXeGchuWr4HJoRiAo4g=;
 b=lLcbDvhauxTwcaKJnwADEh6rSc6AWSz/eR3VCO2iybQWivavfdj17e4ibNGLRqYTegYzVOt6ff5rGR2MGgcDDb15BVaFXKDkjha7W8G6/MZrXfmZAhAw/HTAv4n7yi3l/7RBK+mCbMiJqZQDR/OH+dKK8uhn2U8PLN190sKxF6c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB7401.namprd10.prod.outlook.com (2603:10b6:8:188::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 02:41:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20%3]) with mapi id 15.20.6907.025; Wed, 25 Oct 2023
 02:41:02 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] megaraid: fixup debug message in
 megaraid_abort_and_reset()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jife85l.fsf@ca-mkp.ca.oracle.com>
References: <20231023073021.21954-1-hare@suse.de>
Date:   Tue, 24 Oct 2023 22:41:00 -0400
In-Reply-To: <20231023073021.21954-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 23 Oct 2023 09:30:21 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0063.prod.exchangelabs.com (2603:10b6:a03:94::40)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB7401:EE_
X-MS-Office365-Filtering-Correlation-Id: ce1e5837-7e90-4677-cdb2-08dbd503d435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfCsssfYVtzk0j4s6FPcojcVpv87feNeZ251UCCmK73+H2Ls9rMuiRfE/ibNzjP4ZZgyXaRQ/bu81YbP49SX0W0uxs1FvsKxOKEqAu8gyLEiIbY4oZ4IJBDtqlwONCKIadrg549U0NhrvUadptti4c6vJV6EwOhAwF70X1EXh32jn0f61h9yeEMbvNsbXvaABHhjnFo6nnDGU92hl7dGa6W7ROqcGVV16F40cjs37bboTv4aa6euRh5tNF9NBnkbl5C2Bnbul4Wyx6d/CDzEBgcAQxncbksOuxRQRUmRjZSFw1ItqOMi3oVfr9Fvs1J4N0LjKP2WmN7wBP05dMigwVENdGQmKIk/NTnaVBteJVrEXBosaOdSg7orBeC/9HXTZqXZstvexAAvCglojUecv9HkyndfE8/n1pP2LBPIvKJ2PZ6IS0lqfy2DvPDNJPkqwTIC5HRjN+0ykUJ5t6UhtBUh7od6pXq8IuLkhiGVRaELRCVkXzjg/YAftte95gxs3OfK7RUbmHLXZoKR9JSdujTAKLZu3bRu1n0yc0xliOmyCOUA263fMus9kDOY/qOw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(26005)(478600001)(6512007)(86362001)(6506007)(316002)(6916009)(54906003)(66946007)(66476007)(66556008)(38100700002)(558084003)(6486002)(2906002)(8676002)(4326008)(8936002)(5660300002)(41300700001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MgHp1UynTxkhqSPf7y6wvdHhVQyrDeyavw5onWy5/hiGMn4BW7tiCr7e+vJ5?=
 =?us-ascii?Q?gftdcsCxKeSFJ5diShT8qP+fPi5JG9V6h239Goxv7JHZLbbRF+nd+gcV7/Ru?=
 =?us-ascii?Q?9Uw9XDOuZsAfUFUDiVln60jpVtSoBiPJHXj0dk5XrD3QrtrE/EmSWvylZ22T?=
 =?us-ascii?Q?tcgwmzcZXzZxMCa1zlJ1p5wXs1f9G+Lr9i+q7924biN3y7/GNOnWoYB3Vk4l?=
 =?us-ascii?Q?AeeoCzSy8lYct9RzZCtbguUNT+EOrOFJqNaN1RRl1Rbq1Ac6gv1c+iHUNBos?=
 =?us-ascii?Q?DPJJQSl4ZoLifuH8de8YvcenU30u3F7wXAO7g/BsTij27DlhZq2TOID1IG1K?=
 =?us-ascii?Q?J3+5veq2sBUcNh43YtXaofxhFeXyzlOqBrQ67zv3KpBsGZ++zhwtEv/I3liV?=
 =?us-ascii?Q?sQq2JCefwrcRWS+TjWzxqynxexOZ6gAz3mY4qklAwwSd6PZuPjHVe7Wq265u?=
 =?us-ascii?Q?Zw0FQTozUNxtDz5lCb12kMK/W3TADNVHYFejw7jx7rCroCJ9NyonWKltCViM?=
 =?us-ascii?Q?fihaX2Gt3xvjVAlfXiCP3WXSxi83XeZAMfYdop/42bpRC9TaKYaVf6WRH8Zb?=
 =?us-ascii?Q?voVp3JTP/6+Q7wa75jFX5hBGOP9S8mEeDhuX/tgBGtI43EKaIOTDNouCjVln?=
 =?us-ascii?Q?hkmby0H/tIdE48jOqVSPfFX9L0c9JLCYUmk353iwWkMR6jbyxCoNl0GybaIM?=
 =?us-ascii?Q?oKowBPnLgBavUconZEimPMe4FVhzHm/Oesfb2IdOCUWpbM51Isn6PW87Dofw?=
 =?us-ascii?Q?wSvBuadQlppUa7Q3tkJkf44Vq8exySuEbfG3hZvrZrxlznESwDwud/wE9mb3?=
 =?us-ascii?Q?LqMCkmFNej6IDwxLPh+nxk7qKtOI18JDGu/hHzvBEQsVlHfQGZlpu+YCKdnz?=
 =?us-ascii?Q?MHoN+EESj5/Kxg1es/yQzI1WA/g6i3RDpKNYgs4QycTC4xUpiqYzijQWMAx3?=
 =?us-ascii?Q?71t8bRrT6tAKqQ3TKBKzqDwKSfJmz03wba+lces6JJiket/b6e2SpK2QeOgn?=
 =?us-ascii?Q?jhvCNIOVeX8D/fw3XOkzhwO3lxf/sEDdg0XYvfqAIEA8dMlEwMP6xNmE9S/y?=
 =?us-ascii?Q?XsZES0+6zdfkYHBJLQX53m6PqhNDpMPoYRkELu2ATupEaqIDl66siDQx6NCi?=
 =?us-ascii?Q?ESa2+WUV6uNsu1mY/FSNWfieVPNVolbvPvCXCU9l+N0Y2McMiiNVBNIB5/VT?=
 =?us-ascii?Q?yPGUqOnozkeUP8UWMnGU5SqAphsb+d0HcB7TR9KXPgFdH7ckCMX1hF1rXkVj?=
 =?us-ascii?Q?xcscZ7mrgGX5IwEJc/PnOXA2VDI9wNQgTPojgJUSWXtk5323WqV4rJcoa+Xz?=
 =?us-ascii?Q?7mg0QBNTJSdP5OXLCjjPEFQH4rAkJigA5VVG+rpEcTFXsPehdWfSeSFJLHn2?=
 =?us-ascii?Q?9uATinuiKSWdDxB2Q+55MISiWIVVoTcDcnsR1LnTn33qFJQ8+73KzH5Jq/gV?=
 =?us-ascii?Q?lqW86/9+YCpAaqfCj0lIcw+ecCKd2MuCYdsgckyzksCAj9d3ZjxxRp712f8T?=
 =?us-ascii?Q?O9/sByiUXeqHGvkSfBuO20BjSYFr0AFm7x1gyDcuvKZ7pc9Wuvl+Zl6NsQnA?=
 =?us-ascii?Q?oTAQYlxn/8nsKoGvSTxA8SFlqSrHBkeq8s8NO8tYRTnAm7UW7hSGASuzlgM2?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8tp1VK7LrPvT7F2HamBz7CkMqBvR3THXiDzjkHbMEpTIGcBBxO8ulJT3uoMzuspz0NBFmea8dQmQhoAI4K3qCziiVAyzGxgovsRzQlYEDlrwPp6M+5++M3kHOfFZrKJY2imLvoQL/DoMyRsz1Ms89v09dRebp6qlZEBZHbsUdt5b767jJ2eE4Nop1b5jqwVJBEdhIOhl2T2tdpqdhKIx37ZYMrLEpPZmJ4G5TpFy2ljKSN50gp7hanfjwKr//q+Sm5Jxy+khFIszgcK/ehat9svnwC9cMzlgdpm5B0kFPsy+U0lUGjmpqGgqV1t5+kkv5mEqmKPmEK7aNMYjZPjzrIXE+bozqw9NaxDRIEoqkzczuGA5vr99TxGnO3IEVjHLGjDT3nCJ6qFBCAvcuf+nGrgmscyVXY33FxcRAqoKj/eOeUAAW+DLMeHWGy6jj27XA6GEuKOVHQiPRHb+aZXDVxxik9wT36JoOgU0gsodvd2hy3HevJnQp7tcVgjA7hxWC+YAg1VgozE4mLT8JRLDpb7RK/OVTVTG6sJ940L1CzrY4a93ZQ1YzSqY4SZzJqci9VIKgz9l6PJ/1wDSkMct1+oQ4DMEbT0cBvuODkrMig58dQy5TWFNhJh+tVflnskiKEgPKYh46v4j962JqBksXmY+wQMtjmzqrul/iZqjAFBbsCCRsjo5gQ0p6pmFhL2Utc5xzhMAPz7jilYhXwWk4coucGubnRt9fS8hAJLZ6FDIjDSb/8CS5JVw3karhFacR8Z/CBOyuVitQuOtCdTU5aWKaX3Q/SqhUPBlZsMCqXk+K8K5wQw6mS9Nwzs6fNpBPjZOxjZNs4xn4Zk4b4AYAZYAHmv1F8ie9LCbJDM7KVbmOOzf7nOTC710kVpVMq+zsFSYAysR2DjnzbvrLI4GvA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1e5837-7e90-4677-cdb2-08dbd503d435
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 02:41:02.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mgp6hWlQFLMGyrAxMOqfflWhEfz2MpJo4/3rokgkj8DTfHs51tkB03BITZ+ggkN6yvs0nHtbxeLEL2BcrLLIXb2AIVNGq+QV8gZa7uPk+3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7401
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=698
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250021
X-Proofpoint-GUID: Lo92kM_U2MdHb-vfYeLoeSafgBawTWGk
X-Proofpoint-ORIG-GUID: Lo92kM_U2MdHb-vfYeLoeSafgBawTWGk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Found by Smatch.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
