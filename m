Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F09C636D7
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 01:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBVBfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 20:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBVBfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 20:35:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC66305E6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 17:35:19 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMhriP007455;
        Wed, 22 Feb 2023 01:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=cHcyUFedWNv7j/R87WOygMcerB7l7qBMPXucc2IPpPQ=;
 b=1ec5jxvhgeXe9xYI5LFrpFp7DFuEb0B8ryhpKi5WiUlA5uU9amn2SyBM9TqbSFizjCr6
 N7A7L5xgkE+5kKSzTD9dlSyyR8pSpQRtexTEhY6FTh35We4YomWAKFzvaTxwfxA3q8me
 BaZs1E4bc7WjzKLh3U6clnpjEqTZmNymIE9miyNVzFCa3WFweda1ymkU1LLnZEXk7zUv
 m+2Nhg0XT+CBtSdFH9aZrr1CP4u39362XYMiqb4dunaIzSRfC37JmfcfM7Yj+WWG7EX1
 eAjFTPUMeaCdtjQTSJqpRNcBHRrRrU28iZ/vv6obIxttlZqINISqXcHY7CsWWME1RpU9 Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3dps3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:35:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LNLIt8031209;
        Wed, 22 Feb 2023 01:35:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45xgd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:35:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cs+sSPDvFUKhIWgI5dsvBs8ckMa3VvX3t1FnSQTHFXK6YwMQgs/pQrlfp5DMWDqLcO0vCYyeZ9II97kofHiXr5qHWtZ5QFagI7U0QwPib68Ut5kZmyvB9ay0/F3be/Yh6Gb3r8GH1qXCUPAyGmwHJh42ht2C5vKFTq1SwSCHZaAE0XlhnJ/q2+BgdauW3IMMMA/Nzjr04T0SkqW1vj9EMZKa5HwP1ea2Ui91uTEujtE7Lif8XjPoKAJSvoz5nYLF7Ss+GFr2GH5vCCDTHpxFO4ChUt+UHZW27HskFbPRYQ6TstDfGoREvCVwXt1aE4C4Pdaw3h0zJtp+5ocYQxUNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHcyUFedWNv7j/R87WOygMcerB7l7qBMPXucc2IPpPQ=;
 b=Wpu6/5CFi/4FGt8w6SGw+J+ELL7pWz7ZpoTLD+lhqYM8/VLL9J79LbQxQYEKKQmykKNSnpfQwH9oKfncTO2ii5502ItC3DHZfVms1UGxa+N2dxzVqcnNFff88tcaSgII6pX3iv+y7U3t+dbhZaRKsJJlV+5j+N1YxP4rKDR9xbeFBGQoCk0hanMcJwX9iWVQYS1HWo0q17cyq80qdOBKF0nXEGHmQzo6WraZQrBb3UBa+p6eOyXyw1wmIKjMW1hoAFpm0RGGL6ydLkt69bs1mbqbOkUfqV7Ro//CQbkHsp8nu2XrBT/gzicFFvXssWttuhO6BSf3HQNIv5Ns0Zbi2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHcyUFedWNv7j/R87WOygMcerB7l7qBMPXucc2IPpPQ=;
 b=KVrkWuHZit3tOSIglbk4R2Sqe22hdg3w7pIwrmxeUqOdTTxvk/V64C6Wf4vSPReuMP/ezqYDPS/Ly+9tNeA8j8pCJbq7wm36ZQtAmLu7Sqz+JmEbSfTI6+QULEKFvgbdJBi49AN9GMoW20x/+36hUfixJgVLj9ujDiOxj01LqHM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB6431.namprd10.prod.outlook.com (2603:10b6:a03:486::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16; Wed, 22 Feb
 2023 01:35:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 01:35:08 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Simplify ufshcd_execute_start_stop()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilfupjop.fsf@ca-mkp.ca.oracle.com>
References: <20230210193258.4004923-1-bvanassche@acm.org>
Date:   Tue, 21 Feb 2023 20:35:02 -0500
In-Reply-To: <20230210193258.4004923-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 10 Feb 2023 11:32:55 -0800")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0114.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 97dbfb09-f6e0-4c20-5789-08db147507fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yON5Q0Hia7tHoXBN+shckzlCaiWdjl0J29Ga45oWrzUQf5WZgqXlbOjT0EXFXlPFbIvLvp4+QiFbxFFwEFAnQ3KP859CJIFVCSKCqD7it8tzP15+Oz1d06sA4y8NEqwS9hBw1QRK3VRukDZXvBWtUeVuX3cUoTbPGVegeajS0s5HGW/Kw4gE8GUnTBNhXKHfBZGZywbtgS9Lbi5rs0aqlHGGEv03hpfsWHVceyFLeOoA5E8Yl5gWnBVCjaJ7FSxtPgknJEbMisuidlQQStnZIZ61V+xyadpoU1AJL4meAyDkkF2UYvo/BUO26OcWY3/Z5p1HpkT0nA3/Cso3r75jqda9f37ZUwQqSV+4lUmvoeSMt+YTU0o3RFWpxRP/6lkUkEx618h8F9r0oP/iUc/4FDz3/bNJoCHaaaKQGnNUault1MN5nzEj+ezuD9aaCBRmc+AvrPLwVcJXjy7ORTRczqKvlhOdw9EDr3rK8ym5GdexPMv1qB1G8JZHzsYYqKag5RJu48HDQFa5yYnY75oHH6Kwmkr71ZKyTrN+TgDXEd7ylY865T/8XThwZCJClFOXTD+YF7jaCMVAv/uG0r1SxtQ2R0tDVb4X7zltDT7HweM7L+Vl5THQBh1WKDGst1R5tRFi3VgMla5yucW8Ez75zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(558084003)(86362001)(316002)(6916009)(66476007)(8676002)(4326008)(66556008)(41300700001)(66946007)(54906003)(8936002)(5660300002)(36916002)(6486002)(2906002)(26005)(186003)(6512007)(6666004)(38100700002)(478600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mad6HIyeckg1yH4FRaxCi+JNxK6uh+3s3I67pvzP27XQ4ASvF/gtYxoOKE+R?=
 =?us-ascii?Q?L/p9HJLc15GJMaP17tDS7e+AVH5P9h81/9wuL3Mmxk0OOe3iVcVkUhE73byS?=
 =?us-ascii?Q?2q8rFFo8p7Bkzt+GvTRErhYx4YGayjYsytRtVY7ogLWQgcO2L2QjoN9vFtxr?=
 =?us-ascii?Q?AYVT270H+dpPOWCLcj/NbvHtxdYg16dTrBWi53mCZ41g6RLVeQ5BNiC9oYAN?=
 =?us-ascii?Q?6zjsJMnU/fp+AKtyYZHH4KqyIQVw0xv6BESPFUvlcFM0iiXrChATVifDHWnU?=
 =?us-ascii?Q?W7zA3vezET4xxxxycdNbiQi0RtPDzpWV9VEmg32xxmr8ADv7CRCWTnvaTQUs?=
 =?us-ascii?Q?y7hFrhb+t1rigwxVUMN2N4QhcH73xfwiLEiaThiIYhBb/UlDdPlw7IItxQN6?=
 =?us-ascii?Q?/Hp9YvWlw1cYHh3+ZRWwq37sHz1zp0HVYgYldyiU3CqlOzkUU8XT0fEwyprJ?=
 =?us-ascii?Q?UQ8xIgEkW+TmsFjwt4o8mzTuVxOYlQmNYIWeX4sjmJlFxdJLlyULRY7FlKKp?=
 =?us-ascii?Q?HkNpZyt3iKVW6IFEHcBfAiFStmRt2vYYCUIagKdkZ61QI1721oz36B5BmK+M?=
 =?us-ascii?Q?52JFXFUgQN7u1KjG/pU4B5f/k41ZGVx5C+tyfUidxoEiEjaGOlDn1gdO7KCl?=
 =?us-ascii?Q?rTzcgQffg+5IV7tnkGqO6p3lQV2MwRfcU8OvMXPMhzRXbcfv/AJxIH1QFd25?=
 =?us-ascii?Q?hp1iwiP+yaUT2L0ft+Dn/GKEJxL/O61BXZtVJN91G8Ix1R/jRMEVk80kUiLM?=
 =?us-ascii?Q?0SPaqntIj+B1CKhtogQJKAYw+3OGG23JhjJryhPv1qZcZKCyrwDhhcwukiax?=
 =?us-ascii?Q?UMHQnRqTSKEHwTMOxkUYT+VXHCUQXTn+IQDKvgu3njWBhjOix/X2JpDB/m7w?=
 =?us-ascii?Q?ujaWIfx3hyyPbkowfgSCrzpvZdJncfAPkNoblbatS1bqZpafuCb6Rcq68C5K?=
 =?us-ascii?Q?xPZvzvmOnwTDkkrMKqFO7ya2QbiBQws03EA9JdzwHatDIfVvFBHvGx44aYdA?=
 =?us-ascii?Q?qCwBujyFe8r5uZ9h6tBlF/MNElIuhTaW7VlP4/l6DsgHYPpb13f5OPW+ZXKa?=
 =?us-ascii?Q?pgoP8+cjMvgRvMfA4GRlxhSm6VHtYtsP/Flaou0ZKY/gqmzh3lIbsycyGjwF?=
 =?us-ascii?Q?T0eKpejQAaeErbJvPSIVFXlZvTbrNv6KZA15gW/9Qn+L+4pAjQkUXp2UkWgj?=
 =?us-ascii?Q?dOGTZ1nzOi4XvmUY4V0p3gFxMVj5w+lhzTXeFYp9tTXZH91Pu0XPHprDTbfp?=
 =?us-ascii?Q?UrpCmNqJav/Sq7OL8RqFujaDGseAS2qs6pCLTDVK0Gz3ewxeylfJdddt/Azg?=
 =?us-ascii?Q?UnjUPxLzHCZEoPIZKj6+j/8dzwJmw6R+Rd54oM4b+UQcFVPkG1NrSSZxAuDH?=
 =?us-ascii?Q?p2TILZxauft4DFFXcHeGZqZwME7N7zHXsjRyABgOjSomefQKBwKJ30ql99D/?=
 =?us-ascii?Q?LRMCvAxqG2hBMMouosxUEjPTpV5/EqmvrruTgOBc0T/Bl7LgnghbLZTf8wP4?=
 =?us-ascii?Q?GQdv3tq5QOBQGPr7UWkspaTGhOlHrTJ6TxTgUaIlb/lFkC3cJG9gtwF0/0Ng?=
 =?us-ascii?Q?KK+dKW/ksxrHZ/H4WANVOU0KHDv1TKKk/VKFqHq4dyId3xUNTMob3mZVN3xx?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WpUqmturKwhP4j/viyCDvlWQHuQdVPza4SBsAvTlC5GeA+dOWjWamFVYQvIAFwj+G2W6BYM/I21e2MeqHdYfxP9i3q+FCkhUT+KY1eX0XDnwV7OgTpLyAEjUny1WxQ+Q2yvx0gL8EJAAoZw3uMgR+ElgOM83y5QL6HmFj9rB/dTXXWYV1zkxpjhjxC0p9tvfHzDZkOc1LRvPOVNaX3nN64Fy83o/WsvnlR0hSuCsbPvHQOrdoVVttVexviWL43ldpxKkZeq8GXzmz2tlsQnvuRKGZG4YPPjefpUQETqEDlcBIq72ykut8NmVGlZZ91ot3XlfpvIMYr/kFgBKYuG75vHmeBUeNs0VTW/0W8vkuIXHFho7YHT8wTLhEXPStMerL47vkRdaFr3AZbiR0rM0LGA+4CwpPYqoQMeL/G9cMWy/lOpzXJjQzX8GXWFMW2wXFPxPpQ49mgQRtWAR25g5BUgAzGS7ZouZh8F3w7i1NUvo7iOC9RXaCIVbO2JcwAigrlhZTxtwMvcF4MBREgNmcIjyzS8Ph0MUvaZ7UY3o87bqlGN9Q+9c7JZBUcV67HfOp5gjko+xpx3QbVrswJR1Pc2obWhU1QHffesiNeiQskXgTKPRc4loqpE9Vw7R+iwXLcwOiR7gzVNkBQzN1OwfhgFC26XNyFQOSaswwU+slz6cGGNrJgodjiLqtM1Nc/rggNfyWSqNoXErcxDNIWe7Jifb5IXyIrHsexX7DzanjtXSCJXqionoiW1+aOlOtiQ/OzQzjYvJ4GPlTpc1WsVQfWa3B37qsWEqTrZPXEHxBm4z6ldKWYX70r+FsOT6c7lKRSLr9FUIKo9Q9Xxt2PAgk6XLl4+AjiajB0LvJUibj00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97dbfb09-f6e0-4c20-5789-08db147507fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 01:35:08.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BSGc6zb5sZS8cCbcAlERxemp2IONnhFBrqROBHWwrIvLMM4qn307iK6saMxZFI7bR8deyUfYKcFW2fys1HpZghHbhkrqY/TtGr4C4h0d75s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6431
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_14,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=684 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220008
X-Proofpoint-GUID: kQ6MTf2onSG1815h82J28Ehvd7dpvX1c
X-Proofpoint-ORIG-GUID: kQ6MTf2onSG1815h82J28Ehvd7dpvX1c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series simplifies ufshcd_execute_start_stop() by using the
> new scsi_execute_cmd() function instead of open-coding it. Please
> consider this patch for the next merge window.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
