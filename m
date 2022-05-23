Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A77EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 07:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiEWHXy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 03:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiEWHWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 03:22:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455FB11A29
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:14:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N6evZq003786;
        Mon, 23 May 2022 07:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=G8EsQLwoApVwJiBubC9svTx2EEYXnqkWBAjgdhQrxvg=;
 b=cjYiHe1lioVbpoFZ1asxurbmEvZkOeG6zViTIbztGyBM3qEXuwSYnVPL1Up3vmOdBp91
 LIIDp0/3o70k2edQa1s39FQaq6e4XsACq7zvBNw6mcwphpIPXAJCaA39VxZkrXyaAS4m
 b8xfbdj1jZN1hfyPvHaOJ3pQepleNFTs0Kdt3uW4yrylfDBrJwcxPWIIe3x/eqxte+pd
 QMZi1XmAFFLeHtzaKruOQLij1NGUjx5ouroznInhDvQyYGaqs7GsPJrXKPhyk7uRmfJH
 YKVprLh4t4nWLOuKBCB869C0vyMn1IQ6a+12YiyC4lPERn9OxrCP6BFNB0ix+hu9D0fo tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmttd7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 07:13:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N7C1i2019937;
        Mon, 23 May 2022 07:13:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph7gydf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 07:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJNTKgTMqNlpnCWscc0qTMTkmyzCerFx5lg/0SGeN+bF1mgiNjFOn+oDKx2TrC62ZT3Ov5wYDIp7hUu4BixwJL6+7UWJWqquq4SFlAYVt4XG0t2IdRBzl1cNPl1+jjqP/8PwRjDVz0waZJ9UhEMnExd7T68iHnf6XIAHMhVkD7X5kv581iG2L8spTFn/MRuyJW4Fnl9KjdURhqn6egDDPKFpIuq1Jb4bHFqOexd9NP9nt7J2wF53Bl7U8nBMXqt3tmfHQSmXr06LeufkmPqjPreMPhHiz6LuUgIIJm4moxA8+ne5qQHjvo3hm8bG8YOVFEUDLfc3eTijjcAG8QsKyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8EsQLwoApVwJiBubC9svTx2EEYXnqkWBAjgdhQrxvg=;
 b=IRSWRFDmT4ejGS0TEdUTQveSk+T03d5+AaNJsSuaAHN2hKRnYL/ZSyUAMzMNVq/3EGMQFtZJX1nuwyYjeGgCyowO8mmFk6UwpPi8ykE9iAlloHz0n6qSph3zWSG0h8gv5qXdVla5+lJ4PViAJq4IpU0BC4GYNzsQCLlstTodrgNw57AMfWmtHf56O/R5KZU9WBPL6b4a64ntzHvIz1DUbnu+begBhzESJp804TZy62NEdkIdQ6WAg6nT6C0K90Y8H0FIBaxQ6LNOkZ1QN3NFe0RrmQ1SvkQN0aJOBJLvExZj1dpscPgOipOW3xW78PLVXSJUp5OmmMEoOXW+DZhvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8EsQLwoApVwJiBubC9svTx2EEYXnqkWBAjgdhQrxvg=;
 b=LPPsWhcs4B+q0h0C0earj+rADzSCd6FXo3l0xmWhd+6gKWKm/6VtcnNFtff1o1ktVf8HAjC8ea7FONfQjZpFeCbdKxKu1t5+sYF9bFqjHpCkJfOjXNhOge4nzJmZcasUB8unJy56LB4WcWu64o/oBq/hxnF6BNPHV7yRKXmKh4Q=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH7PR10MB6107.namprd10.prod.outlook.com
 (2603:10b6:510:1f9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 07:13:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 07:13:53 +0000
Date:   Mon, 23 May 2022 10:13:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Try to save power mode change and UIC cmd
 completion timeout
Message-ID: <Yos0J9BQ/mO/aymX@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0164.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 878c69de-8c23-41ad-a503-08da3c8bcb35
X-MS-TrafficTypeDiagnostic: PH7PR10MB6107:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB61074B6D1C7CBFAB45A1D8D48ED49@PH7PR10MB6107.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NaKox+dj1/A+w/9Y9XV7A7WE9WDYIDFCIp6tASkw/MLaHfZhRJjxyQGJGtgGpnRpIWpOJYPCF8qCAA8ARFLhVOmglYongtAE7PtJhkyi0UX57fm22Pqxqb4Kbs27kmthePKUwaV+PTxgUvdZUHZOGyw1Ek8CqZzbVWlqqog6ErEIa5h8ZOvSkG63lcThpS1qSwOVoTtw6ElDD0tGJZsu0Dad/HugdGG+2q+1QtP12isH5WD3v5fJi3B0NIstoDQqln5lfWbPksj5lV6B21QupFI1KkDBOAnRwya/X4XDJjpTBvukbP7udFCtYmUUhg1i/5JcgcY5q84pkOyMTCyxn+95N9GLnEKFuSJvLlRxC9rI0KGyqLWdymSlridDJu3pC4rsmInPWojynnFWesGXyi5F7TsCl0PnXHDRjn1csp5e26lLdEdAvhrUZeAhQ3TyH2xqSe0rbYwdMpLWp6WkXtl5/j9t7DmcSyrfLIk4Tqw8dSS6OS/kqI1jDe5Rz+xSGASw76o5f+6IlfVXdaZtfqNVjiKhZQnSSiMGWVrZoxVDPteJaSQCuvnEHr6C+bwaRiwQAQQZuh7OdRLyyCZCQkmFa+/rKXid6239vne15dDaRHNC6VEGctNlaR3MsKGrf7DJ2BMm24lJCPSsBQFgGTUq81TB+Uxn3gPDcysaewD7w6Q+e/AMPQkxe2z9qIZwcAx9R1emPS4Ocpidu5ABZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(66556008)(66476007)(83380400001)(8936002)(6916009)(8676002)(4326008)(66946007)(508600001)(52116002)(38350700002)(6486002)(38100700002)(6506007)(44832011)(6666004)(6512007)(316002)(86362001)(5660300002)(33716001)(26005)(9686003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B35sEtXKqr5MoBSkoeZbIBKMvIvr7Z6Zj7tl7F0h/KBlAZnOyW/jabqHoE34?=
 =?us-ascii?Q?reOjnMx4aP1JVgAJ0BjJPnDOtphyVCr4HS3oUvnNcYZ/TFqy1ppJ3YL17DeE?=
 =?us-ascii?Q?dZghOeLc1s6XZLYEmIQLWOIW4lXATnfMBFsqmRTIhFcW3rGPDP+rD1tWAD65?=
 =?us-ascii?Q?Tl0swUf5TIliLvZODM8Q8aH+zrGNpXtQe/CNLsAMzCUYQtphorpZHbAp9RFM?=
 =?us-ascii?Q?ZsQumXwPzr2K/okRSXDO7ADuTalEu0qg/LM8dogkBu0XH1lA6ZCqrAkRIPxT?=
 =?us-ascii?Q?IJ/dmcYp5JSkIfWwjqAnpvjTG9brzAXLgFz2rLbbGVmUXxsA2eQCmiUY0tf6?=
 =?us-ascii?Q?eWhYg2MLvtRoF3jmHsOnWXXVZBPm6DzN1EwyNCo7UFKwMCHd5GG1rf1sKsLR?=
 =?us-ascii?Q?soZnZMWCRVozp/OLHQTpH68SQf3/cIivAFirsE/W3AQW6QjOzgp9AN7zDyO8?=
 =?us-ascii?Q?nqZBJpmWlaAyUHI2Szz3Yi/S/pPEEr21A8ecl0Il+ZHHEyLuMYhA1jHC9HpH?=
 =?us-ascii?Q?UuExmCuWz98npnmzebgp4yHK31FgDYcQh10zUBDJsSLmMGTpPr34rrk2Q6gP?=
 =?us-ascii?Q?PNlNdu+Kx3A4fnnwv0paX2AAp/UjNTbVO+KwYF9KSCap4aBCXyxwPBkxbAxg?=
 =?us-ascii?Q?8hvrLaxU5KUQ/pHP1amhr1PmqZRP7JdzBtdUVolJgNLYEYkaa7WbDfxPfp0H?=
 =?us-ascii?Q?/AAuHRJgnuTUpjAoByccE8R/KoJ/2CDKy7ZXXI7eEwaYSFYEx59UmB655DwD?=
 =?us-ascii?Q?O7/wOS257Y0fRWuwNak3S8JcXTeeu3zQT1fKTknkVnu8ZvUWoVUhzPsQpNza?=
 =?us-ascii?Q?3rvUMbTSWBkeggEWE6//1a+lWCLosMShKGLoMKZfNY6/h8jyhw5kQkuaCPjj?=
 =?us-ascii?Q?If1mVsEP+fbV3xddnHKSYiEv0UUOBIpwSsCs8SKA/Krs8+M4zSTuyUQU+xqE?=
 =?us-ascii?Q?k0aSwEJ+f3m4SiPdy5KfEFtpxPxxAIXt943o/d8xOGwxwmSdbUErpkcCjh6D?=
 =?us-ascii?Q?S0mWQNekPB9CosKuEaeeqDOrajeXIOT0vntGuhjCUfbKfcju3QkOL//ZhWj9?=
 =?us-ascii?Q?EXMUK9XyRzCACPOgUBBrSqTLa33bPjpHbE4KEX48F4oZ2zSyxo6OhetUyOpt?=
 =?us-ascii?Q?nd5DqJAfJ+jHCFUkpCxxId0Zw/PT98s+aMF5BAEu+IRfNU0jUGPTchB6h2aC?=
 =?us-ascii?Q?LgQEufcXXXeAYGXkuqSglfiJGL/3Ofnuo0kdiWy2AiTm7pHm4ktd7ceqHsq+?=
 =?us-ascii?Q?wGDQ0oPF0SPYQ4CyK7wMdMJTtm/CV3duL9a1w5y8wy+a6JdmuDx07uI+s+SB?=
 =?us-ascii?Q?Qkl+OtDsP/PUT6nirlhs40TWfEaWTwizNDb+J8xibzCHdcXbD6frwLnYM4lH?=
 =?us-ascii?Q?NO+Q4NFwlag/yxGuWUGQg4ajNKUo7F3GWDRlpla9zJZ2IEiCBDSDcheeP1Y/?=
 =?us-ascii?Q?k2Nh52dN4Cq0CmlUBE+e96llVU7vSNxTzO0lJgvYHET4vuXD2u+v/UHToWiG?=
 =?us-ascii?Q?kIcbJN+jS0jZu8OEEAQtt4w9VL9mLbRgIXOsiemdjrMK32YiTOHhtNyV0dD8?=
 =?us-ascii?Q?oc3SbtfGYZa5J1Zf33H4KlObprFutbpQ5F5AFDSXyd3VwqWosKZjDE5xxgM7?=
 =?us-ascii?Q?wK3GZmMX8m6YO4aUrImUDHrYuWle+X2a/KeWYaFNk0IunQwrkPCP+TdXXJdT?=
 =?us-ascii?Q?SVahLW3/oK/2zrG9SqVwXq0h3TSY1z9A9Dz8aeejxyHO7/x0au4bNVLR+IEv?=
 =?us-ascii?Q?DYwLqY3FUqCcYOqpDBJTML/ahVs/Iks=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878c69de-8c23-41ad-a503-08da3c8bcb35
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 07:13:53.5163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OSteXocffBu0/+vuj1dPJXChvkHoQerDYlBfQx604kqCUGwUennPh3QRIv8o1JzqqVEgTF0rlI1cj/WrgDMBYka94m7tMCbV8qy9Cb2S0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6107
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_02:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230038
X-Proofpoint-GUID: y1G8n0AtZ_Xu5p_ct2DZLPS_6aUSz3SM
X-Proofpoint-ORIG-GUID: y1G8n0AtZ_Xu5p_ct2DZLPS_6aUSz3SM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[ Renaming the files means that all these old warnings show up  as new
  warnings.  I reported this two years ago but never heard back.  -dan ]

Hello Can Guo,

This is a semi-automatic email about new static checker warnings.

The patch 0f52fcb99ea2: "scsi: ufs: Try to save power mode change and
UIC cmd completion timeout" from Nov 2, 2020, leads to the following
Smatch complaint:

    drivers/ufs/core/ufshcd.c:5283 ufshcd_uic_cmd_compl()
    error: we previously assumed 'hba->active_uic_cmd' could be null (see line 5271)

drivers/ufs/core/ufshcd.c
  5263        static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
  5264        {
  5265                irqreturn_t retval = IRQ_NONE;
  5266
  5267                spin_lock(hba->host->host_lock);
  5268                if (ufshcd_is_auto_hibern8_error(hba, intr_status))
  5269                        hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
  5270
  5271                if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
                                                               ^^^^^^^^^^^^^^^^^^^
This code checks for NULL

  5272                        hba->active_uic_cmd->argument2 |=
  5273                                ufshcd_get_uic_cmd_result(hba);
  5274                        hba->active_uic_cmd->argument3 =
  5275                                ufshcd_get_dme_attr_val(hba);
  5276                        if (!hba->uic_async_done)
  5277                                hba->active_uic_cmd->cmd_active = 0;
  5278                        complete(&hba->active_uic_cmd->done);
  5279                        retval = IRQ_HANDLED;
  5280                }
  5281
  5282                if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
  5283                        hba->active_uic_cmd->cmd_active = 0;
                              ^^^^^^^^^^^^^^^^^^^^^
Unchecked dereference

  5284                        complete(hba->uic_async_done);
  5285                        retval = IRQ_HANDLED;
  5286                }
  5287
  5288                if (retval == IRQ_HANDLED)
  5289                        ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
                                                                ^^^^^^^^^^^^^^^^^^^
Unchecked dereference

  5290                                                     UFS_CMD_COMP);
  5291                spin_unlock(hba->host->host_lock);
  5292                return retval;
  5293        }



regards,
dan carpenter
