Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021BAC41513
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbjGYLR0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjGYLRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:17:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7121FFB;
        Tue, 25 Jul 2023 04:17:05 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oP0K010966;
        Tue, 25 Jul 2023 11:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=JsbQ4St4pnjHok7zguwd2m6XButZEp7he8lxbIIMx7g=;
 b=tQz1/eJOIfbCUZHoXsktIAmV/bo4x1HE3swSM9MUSFPVmD6vvKo5jD+JKYwEJFgg4a9c
 JN93p8WyGvHGk9YEwHsw34jJmcMQfaA9W6vy3lz3Ygt188LEjscBC6Y0thQ5dBlIDMh8
 OuxmBGuPbwaKuwy8eSbYe7bTwCHAigqZfa8DbIRi+dK7zsMjgCAjQyjxYS4UWINEF3xl
 JAQbHG76u5xihq9bC7ffRWH8DqqJ3TkY7bQFiBsw2QC1Pyg5Jpu4cwxuOsdcSN8VC7bF
 D/bWIghWEBYyVEYmpJeMtRO4h7QJfbrJqjShKI5PAOTeaqJC4vFPfCetuf9sCE0cXXz/ aA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3mt8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:16:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA92oD011522;
        Tue, 25 Jul 2023 11:16:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05javp4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9cvn03W65sp/F2YSyugq4aEe30q7nnG42iarjGcAYZG5/9RCt7tfEBE4KQFwgbEi6GtZBuSrz8vq2tDOMkBQbJHBOuSjfcCjZz3U923AR4yRiN5PqfhMt/XFSN0Fhm6qtYz2NHNNhGfwpJbJoumqw9hd3jW0a0N1gC9jwBBxcl3RLsJi/yMKLnwHYb9A0qEHGLwprzRdnspH+/kViJT2Zlorg49HfPqQIkvAUAJ9kI+jTvPJhH8hvMQlYZItfwwC5bxCLxskGx5xivvDMZhoYgb7/eOBTcKfnZons0YM7CVvaif/uqVibZKMaoLnQRjfY0/MaV7KlGHztpA6lUbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsbQ4St4pnjHok7zguwd2m6XButZEp7he8lxbIIMx7g=;
 b=cy/MKlXOmQh4xB3+ndRLZNCC4HhuJVJatF2BsTbfz20GbSJsmNvRiL8vjOeG3wK+jA+bk1CR7RWquT+VpFflrIkCHwPcyPesvOx9JX2CI+3wbDVnkHZreb04nXy++KlgUOVsIdahAhm5ZISwNgZKyS8KDnpc4jX0JWanRNL9HMbiC4W6hNImjW3OsPhc1+QhwOnKC6FDgGExkJus/66mcZiOY2JckPR6kY/Pj+E2+Zp/l7QQaFbJus5V1J7TTAKUCS4mjI8/sKoeXvtdQYsWLLGg3OhMZYtTpUmtI7RQZ/v5irb7+bf9e1rvWJP4qNRXHZqSBIG89D59JoFy1tH/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsbQ4St4pnjHok7zguwd2m6XButZEp7he8lxbIIMx7g=;
 b=VQqrdIAIj+vn6wGbMpzwtmttgLgbVB53G39rOfwBgOZH83D1wp4BG/Eu4m5WVyjfpCI8K7fMgoF/iwOODXx9SEeuwqNt1iDNR1RVDQnI6zqeL4+p+3d6hO4lP2l5DDI1oPY32UN/ZEBYa3U8tG9RlZrQQbI2ABorA0rpEhojNis=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:16:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:16:49 +0000
Message-ID: <235783e3-3598-a162-000b-28eff08442f6@oracle.com>
Date:   Tue, 25 Jul 2023 12:16:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 7/9] ata: sata_sx4: drop already completed TODO
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jason Yan <yanaijie@huawei.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-8-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-8-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::49) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f64e199-6cf8-42ac-7598-08db8d00a3ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgApBzST9uKBR3PWXUeVXkzjXmqf5BLo6vAZIemzZg4SZ14UTTkdVXDtaGaYkm6/vphCYrbBvYMpGT3/BRsu5JeGGz+O5e7LRQjUlqie9oWFyo4q+VmhPj8FFUaz/4cIsmHKVKRgcXukxuRQMGjgxYpFVWM7hhsEk5h6PAC5C7NO71GGwx2rZiPdYLrsk8OUlB7AXi+FOo6itnbZ4Abl7+yY6+6VnUXmSS1V/Zwb4ltYFuSu/Yf9MPsozC1PAlv7p98Hoxwv/yuwEm9C73AZ0jVwtZAlTzMvj/faZSH6R1FphR38TxJ1QQsrKnKvzNRMaK1bVAX4m38KcKL1fzv6LqlngdXsaYmj6wRZYKoUrz00yqPiFP6diGItn53c2llSxCAD52sYBt+jt4g12VxG7KRadI+BMi70CpQG27BGK4EH/xjDiDEky12hmvfETm+s3w4Gn+zQsvE2rTTE84fHOhwiakdeYV5qBd5CighvbQH45rwTbDkXycxa5hVd2SkwZiTrSACsPydcp3CCNFYTZuG4UTPKUWGVab+5HUolnqU/gptJnSSSfhh+9PAtWdzJa1CgLBM5C2bpID4V8RFrt41LWqZv3NnG7WRUOQ4ZKM57d7uoarH1WR/DIe37vN9/FbSzF/M1KdoGYkDrN25aUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(41300700001)(316002)(4326008)(54906003)(2906002)(66946007)(66556008)(66476007)(6486002)(36916002)(6666004)(186003)(26005)(53546011)(478600001)(110136005)(6512007)(4744005)(6506007)(31696002)(86362001)(36756003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjdFSTZKV2k0ck9rbXBBdGR0VDRrdUFyOUlraTIwUjlReTRqZGoyMG5ISjhB?=
 =?utf-8?B?WWQzZGg0aGVBbmdIZmlhVnZCN3EvaW1Fb0dGMkhQVVIxbFpHRElqMStqeHBw?=
 =?utf-8?B?U0h2SGRaRFJWNUF1WnlHemEwQVZaclVpcWYrM00wMy9zNW9iVnFud0JGdTQ4?=
 =?utf-8?B?Njd0b0svM0pvL2h3MmlCQjNyczBtckplUGpIUzM1T1VZWkhUY1NlUCtLOFVi?=
 =?utf-8?B?dlZSU0p6OVd1bXZscklSZVEvQXVjRHBTZkthb0xXVGluU0dUSjRPSkVWU0JT?=
 =?utf-8?B?NmkrdDhKc1hJV093K0d3SFpmdDM1Z2hRckJieVlvTE9aNE5RSmgvdUo1U2ph?=
 =?utf-8?B?MHFYT3dCaFAvT1pZQTNwSDR3c1QvYU5nTFNTZjZjaVA5alJyRGNXdSsxNWdu?=
 =?utf-8?B?czk4N2k1QWY2ZUhNblZYaGJlRG1LemVEdlQxanJjQno3S3dqOEdkMHZvRWc2?=
 =?utf-8?B?a24xaG9HOWs0QzdFRW1OVGVpMTlya1d1TzFBV0I4R1JCRUh3dlRRdkgxRG5V?=
 =?utf-8?B?eGJjcldaNkZvR3FjdjJGWDF4MjVtUTBzMkx5S1NiaDRPK2IxRFJvc0ZYNTk5?=
 =?utf-8?B?OU92ZW9UOXZVcTBPVmRiQkVGQXI2cXR0a2o2Vko2aVJTbVM1QU05YXJibXht?=
 =?utf-8?B?cjlQbjFjZy9RNHpYaDJ0bVpNZjk1NHI5dE5ZWjk2cWxWM1dUZTNMNnl5R1Ay?=
 =?utf-8?B?TkZ2NU01TDZ4Mm5pdGRFZzJEK2NEbld1OFBXcnpZNXhYd0tOSlVDM0xZRThm?=
 =?utf-8?B?NnZ5M3k1bkdoTTluQk5FVjcyYU5HekJGYnNqb0pZT2xwSzJGRjVJZnkwVVV5?=
 =?utf-8?B?Ky9JNHVrdzYxU2V4ZmFKODZVR3pEYWdrK0xxYktDczhIclpCTUl5MEhEWjBL?=
 =?utf-8?B?Qmg0WGhwRXNTcHI1TS9tZ0d0MjB3RWZOV25HVDZCbTNaZU5kdXo3UjJiMGxv?=
 =?utf-8?B?U2J3bThVSXhVWmZNK2ZLeVIwcWdBV0dqVGppM2MrTEhkZ29HKzN2R0dvdzBp?=
 =?utf-8?B?M3hLbmVIaVlKRkZ3dGVrRWhtQTdGZk1HSHI0MWdiTUc5bitTT0I1VFpYd0VW?=
 =?utf-8?B?RGFYcFJGT1oweDduaGs1YWdKMFdVcnZTbTNIcnhULzdTd1ltOWpyUHgzOFpO?=
 =?utf-8?B?UGtwbzZYMzN0THo0emUxSVJjUGh1Z2YyUytxVVR0cDNkTUFhdDN5Rk1kdE55?=
 =?utf-8?B?Zjllb0RuRDdlbjRDOGZrMEl4SWpTSW5SdWgxcWFITnM1Znd4anRLaUMzZlc0?=
 =?utf-8?B?azgvb3lYTmQyWmxRRld0SDM2d3Y4VmRVREhremlpV0NiNmNwdjFVaXFWbjU1?=
 =?utf-8?B?Wk0vdDEzbUtGU0RBVXM1cDhtMDYvNWY2ODhsbjRDMmFEQXNaM0J1TEQwNHlV?=
 =?utf-8?B?K1ZXYkQ2dTVaSEpJejNNNUJlK3Y4QzAyYk9qN214MXNtSEcwVnAzNk1NVS9E?=
 =?utf-8?B?eFJ3QmpGcCtiYVZJSjNVZGdJeFVzd0VOK25RVmVQQW1xNjBaQi9GVGFXUFhk?=
 =?utf-8?B?dlh5bndVenRCcE5ma3Q4OFJJNWJvNGdnT25BelovUGZSVlFpRDZaRXNjNHBz?=
 =?utf-8?B?c0h3VzNyYlRHWUlDUWwyWUdLUHNqTUNZUGZvdTQvS2VlV2hFMGRaczBEZ241?=
 =?utf-8?B?R1JNenRPa0xTWGM2ZTJ2cG0xRVlwL2ZoZTF5MnlaeUh5MU5oNmdjYlRSSnI0?=
 =?utf-8?B?QU1LekhEN01mZ01iTlZjVmJIYjZzUXB4eXNsRGMrNW9CWXdqVUF0V0RkWG9J?=
 =?utf-8?B?aWZSOWswSk5DSGF5MWNFalp4ZDZOaWh0MlJwZ1hwY212czcvejZjOGFOclEy?=
 =?utf-8?B?U250OTBGQ2g2dTQzdjRoWVFYOWlPUks5ZG0wZlhNV2RWUHl1YTV1Qjc4WFBW?=
 =?utf-8?B?RUh2NEhBSENxb0lxL0lLWVcxS1p0K2I0cVZEZnpOb2RqZjZKamdyNzVUOFIx?=
 =?utf-8?B?VVpFSGpaSCtwQ3NiYUZDU2lJc0VDdHFRMVRqR3MrajlpWUVBMjQrRVdoQ3V5?=
 =?utf-8?B?VjhXTFFqbTVRd21iU0o1V2lVeXJ4YTUxdW5BblB2bFVBYjRlYk5wZjk0SjJ1?=
 =?utf-8?B?dzhwcnVkek9YcTZGVk5EamxZbkZsTEZnK0kxRDRNRkhHTUJxclo4MUxaQzha?=
 =?utf-8?B?bHFMVFJjUjdGekp1bE5VSFN1OGtrSE9uakRpSDBZdWJaQWdtc3BrbXBlZ3RY?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gAiTalmvqf0kJiNaN16HInjJtFWBSmlmXqJmKcVWb8VrRuh/1jbgdaaFyz8Fg9MiK36+mT5lKk2vGiEPHiU1l+TCPAaUJQYns7DlOjqVRu9GOGCLQHoQ94K69dUENjX5/8z1FGESxGDy2zizb1P3wUkPhH9wBWbTsdls2oFDQkPeKslgY6Qyu8FXjhyZaqRQ8NlecUnfxdLwzRXw/2LZf2f6PF4SY8Ff/bZRtcd+SjmUwEtH1/dq4t5fbzk1qGh5IqpD2UBtxEq6XMSDMuWLwOKLvhwpvwmb+Dg2cgNh3vHUCyzBs06gIvXwMmxdb4U0itAPzpRtoaM/MUR0STx86zeNvWS19LnlVxzLR3mXU+x96GtSPxd4iGs+PUlJGrIs+2p3IKtDWOqrJCRLcjLDnDdQr8EKmvrxKbV70RVb2CR287TaHzWeT30ESj6ejbnIJc0RsmVDUtymN4v6BTXMja7dXAO052b2zuduwpdQ8ZGFpslcBReMIv654ngOAwIrONcls/lNpJyoFCg9tB4SRiErUxfkDkOf02pQEUMh0dxrmEFXqof8j847dPa8RKyylPb/NjKUNeq5+A/TVQ6pZFF+i60frkTkmOLyNwU53Ti/g9ECcJCzVpvOPxpH/1dv/oMOp3nCOr1jsosugrB/pPus75j/vpG4NgWnV2UnE1nuoB8+XAYl1wxFo6samuPjLRcARg5ybstJ56KNdXbjJZ1By8Fcx90Q4D5K0tSfImStgVLdrrXNykUgY7nIHEuX1PpEdWtgMC5VcHj1ys3kCN6fV+N02gqzjKaJJCcYbfFUdKbY27icoDIsKGYNan7i/Qjm1JVfrFDE8WFf3bhu3B+qQ/5t85OtMThFuOnLoFxpj4sttzpxtjVzZU6C4/SGrzr/liAnDoC3qKSa7nR/YM2P4ty8/2eupl8KpN/tRj0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f64e199-6cf8-42ac-7598-08db8d00a3ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:16:49.4801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6sy230pYdW2w8mB3Cg0/nrWorwSPrbiJJr0OBfgldl9Ew4RglkHV/B7gAPSvpqIYVQtyN53Fn0aTZCO/TFF+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=990 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250098
X-Proofpoint-GUID: nxYXTnAN1SeMZ6bAm3u-dBkyf7M2vWpm
X-Proofpoint-ORIG-GUID: nxYXTnAN1SeMZ6bAm3u-dBkyf7M2vWpm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> The TODO claims that the pdc_20621_ops should set the .inherits
> function pointer to &ata_base_port_ops after it has been converted
> to use the new EH.
> 
> However, the driver was converted to use the new EH a long time ago,
> in commit 67651ee5710c ("[libata] sata_sx4: convert to new exception
> handling methods"), which also did set .inherits function pointer to
> &ata_sff_port_ops (and ata_sff_port_ops itself has .inherits set to
> &ata_base_port_ops).
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Reviewed-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
