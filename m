Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE2EC00528
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 07:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjGYHjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 03:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbjGYHjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 03:39:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45E01FFC;
        Tue, 25 Jul 2023 00:37:37 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P1I0pL013224;
        Tue, 25 Jul 2023 07:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=LUo7aA1e95NqeSW2yTGMoJYheytxPlplOXkD9zcldBA=;
 b=b1ALk2MdtnZzWbpl5KIDNFwZfmDjrIUdQMSBqyzUGgsoxh1UO7sOC0Ty94p50y1tPYFu
 q2Dh/hDTN1a0h67FA9OAiJAR/tyldwogNqlECPlAIcQQFzMlYPM8v3pXEDhZ6fPsWm4g
 UZRcRrEwhpc0ILWIjJInBnAOCSOgH9z+rD+ClcKtEKaRrSfj/MWDTsSuicB5ZKYxrbIB
 Wjen8q2UE9orZ6+9ZwdJPQrge8BjgkXaph5R0+gLnR9S1g80qfWySxB9hs71cc9H4q2I
 os12oGUsZp6wX7ujdbu7vYvQxlwIHSnDJxVJhzdY+7G8YkPlw5VY0dHRyTClGpSAaeuW Tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07numdgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 07:34:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36P605Pu028336;
        Tue, 25 Jul 2023 07:34:41 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jap1q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 07:34:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAzQReCy8ca77r1+kRvgXItZ5am1HPkg0ds0VT4l/fPL3hBldjMNmBZW2SXAIeVyn31tzEju+fol4vupxgbN23l34v0gE7p9PYZr2JdBwf3MbQTBdUHWW8jZUPIndQ7ZUp9R6V1ye6xt2HPhYbzuVvePPWZE4SkZClWDFfm3UGG7+ADqBHx8WrLfBpPDzTBIVTC0DtQC6mL/0bedo771gZqRuOobd7MXAuFMkmPwbl7ohSFk1uzpT6jrtdE9fo2L23w1Uszsbt7GO6oPvYLOhJIN3cWQH1GA2UfPwb/ipdcX+Xs/yCV0sC2IrCAn2dnZth83fF48aVHW+CFDBFAPsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUo7aA1e95NqeSW2yTGMoJYheytxPlplOXkD9zcldBA=;
 b=DVefk0q6yr/vf5LQtZ0hiPfbZKWe5MOF85I0IPp8vzUaA5dkH/CPzB2X27+hEAQi2EV47AdnjsdvRGy+rPE+VgiJ1S2YWfJeWWbyAJZ6DNuWZWtx304iZgqwOeo8HgEF1piALyiCCD/YGQulvRoIFXvvPCQTqHss5+BoLHzVs4ikYw+WzmtTkJ2iVrzyxynUF65aHcv841a0y3rwH2qw3hpjBePwClVKqUsUIgxxGnOaZjXAqriDE6STW+qbCxDsEPn8ilyAY2FyHOPjlYdWuiV8Z+c5q4LBwWoe070pY5Mg6+Fr/2pagao0nRvm5vM7hZuhsuYU/wQCk4Yc3geFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUo7aA1e95NqeSW2yTGMoJYheytxPlplOXkD9zcldBA=;
 b=EwBtzh346LpH0xPgkSWI/AnI3JaPdCJtdMRkeTvLBFimNwv36xFnh9GkyBoZiJOzTKCgPWwiXuxiVKLwLOK4lqwasKMgy8mS+GJ+M8Cej9YX6ciuzxYDIJJf4Xe1Vc13H3p0GvULyDu3jrxJF8DDRjdISyfhZF6zEmNlh/XwAmw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4243.namprd10.prod.outlook.com (2603:10b6:a03:210::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 07:34:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 07:34:38 +0000
Message-ID: <7224475b-d751-b849-0135-92ae4979336d@oracle.com>
Date:   Tue, 25 Jul 2023 08:34:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 3/8] ata,scsi: remove ata_sas_port_destroy()
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-4-nks@flawful.org>
 <8db40977-19db-2180-24f7-cddffc5cf3a5@oracle.com>
 <ZLqJF03vWDg9KQ+e@x1-carbon>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZLqJF03vWDg9KQ+e@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: f396071c-233b-4661-a5b7-08db8ce199ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9cHHJ/utURH22qRFjO64YrR+C424PAWXp7BpkY+mEOs+YTU5UqVKn5pgYigCdV+AIXIK07XhzvGCV/JRVFc00wOr7gotwPZ+gdswmm0J8cJVJpekXV4khHRAVnm23SqnxN2dlJs0Z18nNs3ILQuy/4aAe3Qk9TZk8k9W2xkkGc+v6ilf226tNseD4mWTj+8PNTNBekmKCbjw4xSyKHJBjO1d9sfmts4ijg2T84XLpAFd+/lEzufGZSuP9x9YcRQ7eEO6bau4kXRBdYoc8+h31gtW5WP3tYT1wlX3DyozDlW8b2Dd9IQruKRx5qRCbuOs4PSlgUhHIMjkFJI+qxhBBcQTUOrJL6RdzUJOxNk9w39J5R8JxESaCGjXZQquFnYNSeFxQZZ71hd1D0wtV8nBHB8BchgtrGWn5e8LQ1K1bakXfL9ASlUrWnovg5045uJVH/6sJ7mTdLaTePjjKxGqLz+0qCR1AFFTRmiRz30Lb+vXN7VTyfirVVLgQWa8wBIAOshFNZdh8IdlOOolYx1exYKstlyaNpd13gQkWm2dbfpRW3L6mxX9PPwF7+0BdifazQoDatLp6qWiCi8G+v1aSPqnF/SPfXos3jn89y351uMAjHCh8Msbcga6ArpV3lXj0yTP2SZdc1Y2hOHfqcT6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(316002)(41300700001)(4326008)(2906002)(6916009)(54906003)(66556008)(66476007)(66946007)(6486002)(6512007)(36916002)(186003)(26005)(53546011)(478600001)(6666004)(6506007)(31696002)(86362001)(36756003)(2616005)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek93NjNGN3hmODkxc29hTkc1SkdvQjlYdGplWXBZVktGUGtvRnpKaUNyZW5C?=
 =?utf-8?B?aVF6SjNGMU5tMUZQRFk2VVl4UzRMUTYwTStPZ01MZ21aYkJnSlMwYWNMU1Ri?=
 =?utf-8?B?VTg1allYQ1p6dUFkem1CTGJKUjJaY1F3NGxPMTBKeHVvckQzeVNnKzlQeGlB?=
 =?utf-8?B?bkF0ZXJaN1B4dGh1cjhESW9hNW0yL2YwS1U5LzZSaEhmS1ExVXNES1Z2Vm5M?=
 =?utf-8?B?OG9vc25oWUtwUXUvRGRmR3pZQWtZUnlkK2o3UUc4OGFUUEFtR0o0VVllZjJM?=
 =?utf-8?B?dTg2MnFwNzlMaU5iNUZ3ei9BZ3Fwa0o0ZnFNSENuZ2lTODVRQlRHNEJabW5M?=
 =?utf-8?B?UFVOSVkwQXdob3BEY0pNSmdWR0xPNTZTM1JlZWI0K2xNaWc1SEIrY09RcFYv?=
 =?utf-8?B?T2VCTVNQeDd6WWVKRXB3M0Q2YmUxUmpZdmxVWkRVMHQzRnMrV2dSazRZaVdu?=
 =?utf-8?B?MWVDM2k3NFBMbUhkbjhOU3g1b04rNy9VaWtVOGVKS1pOenVOWitGQVlVelBF?=
 =?utf-8?B?akhtQVc4blBRYnI5ZkVyLzJ4WWRMNVlzWGhqTFRBTW1ZNlB0Z3kvOVRiK1Vt?=
 =?utf-8?B?cWRMdVNPOCs4YWYvQTI0ZkdiQXZGSUNJY05meTQ0UGV6L3NOc29oMzJMN0V5?=
 =?utf-8?B?dE12MENFYVkzQmhnS21jZ1hOTlM2WTA4YnArakZ1bjdjSVExeTFtODNnTmdr?=
 =?utf-8?B?ZVFvZVV4VUlpdE5aZjlEU2lxdHlMS1hxem15V3lJZjA1UXRlamtvT2NyRHRO?=
 =?utf-8?B?cWdwWUJsTVpUL0R1dU9uTTJFOVBuR0JScHBTS0N6c3Z2OXV3bm82QlpuVlV5?=
 =?utf-8?B?UnpDZUg2SUQ5d3JXUm1QM3FpcUduUU9oeXJKeTB3My9VUHNYODJtL3lSMHAw?=
 =?utf-8?B?cHZ0bjJUZUEzL2dQM3MvUG5QVEhKT1hTRVhYYmVWTzFwV29nL3pWZzltRlky?=
 =?utf-8?B?cURPR0ZvRTJ1UTZkZ1hZSWV2UXJ4cU92cGlWOVczbzIyOHo2YWpLMWVia295?=
 =?utf-8?B?OG9uMWNFUllTdVJOUUpuNFVNQWNNY0Zyc201bkNISGM1T0J3OVJuK1I2dzg5?=
 =?utf-8?B?WW5jVjJUUmc2RHlTQ1lHODBpTURhaWlpUS8yODEvT0FYS0ZJVGM3akgwb0N1?=
 =?utf-8?B?R2hBNkpHaVdKb3ptcHRPL213cktmdlhVNVBLczgxWklJOTZDNWRHSEd4d2VP?=
 =?utf-8?B?T2I5L2t5RVJyWFppR2FZR0NIZnV4eWxZSWovU2FqZyttakR1c2ROWERBSXlB?=
 =?utf-8?B?TklhQmtMMThBejhPekd4Q2hnWldBN1MyU0pRMkxmQlpoSlR6bEwzRE9oZ1Uv?=
 =?utf-8?B?bTkybXZCUnhCVEQ4VFV3TGowcGUxcjBhY2I2UmlCZi9ZbmpJbFRYL0dFU0ls?=
 =?utf-8?B?TkRZb2xkamdnS1lJNmJuMTR5akE2aFlISndMd0s5QzYzMDBCelU0NytTeFBl?=
 =?utf-8?B?TnBrMXR1Q0J5RENvaWU4c2k1V2oxNjFoQW56ZXI3dmg5STY4Y1J6RnFnODZ0?=
 =?utf-8?B?UlBpeDF4aUNCR01oeUZxd2s3bkdXbGYwSElZejQ3WFc2TGk1ME5QejdvWTFG?=
 =?utf-8?B?VlZKb09tdmFIeVRwS0dhTzIwN25rS0RKa0t2c3gwbG9ZclprR0ZwN0JEcXhT?=
 =?utf-8?B?aVpBL2VxNGc5ejVSWlN5VU0rMVdDL0d0WlNVQlpkeklhQkw2eWg1ZnVmUHM0?=
 =?utf-8?B?dTNwQm9KcUN6YVZLeGZ1MFJjYzYwNkNUSUUybkpTSjRuSXRjWWFRcytKTTNY?=
 =?utf-8?B?TGZGcFZLNWlDUjZONUU3Mmt6Y2d6cFo4TklzdlViSTBrTDZkNHhoditOVHlC?=
 =?utf-8?B?ZkZiWmFldlJCNC9ZeldYK1V5VG1KRWNtdnBjeDkzU2tZM3RJYVl6UExaSTJi?=
 =?utf-8?B?NHNIbFZsbWtHVm1MRyswRWNKQ2VIQ0Fxb09OcGJ1NWlneGh3bEt2UVFxbW40?=
 =?utf-8?B?LzZ0UkR5RnhsYVloUGdzbGw3ODB4UTdzanByMkloVlFuVVBSbzlsZkFMSEg5?=
 =?utf-8?B?S0dLbUFCMWFOTHpMMDhuZWs3QXdoUkQ0YS8raGNmRkZ3TkJqZFFNY3VTTFUz?=
 =?utf-8?B?ejYxUWhGYU1PbmNnRE02c2lWa0FpaGUxUkV1WmJ4RVB5aGxuQVlPdDk2T1l0?=
 =?utf-8?Q?jGt7n27QrWhTeAMt9RgdTMk0c?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dFhPUkl4cmcvWnRpc0h4bzBQU1l3S0lsQ3B4WWZSMlhhb3ZVcUgyYitGWG5Y?=
 =?utf-8?B?TEVTSjVRVnk1dVhVTC8wS2hVemlta3gyWnlyUjhWNkJmL1VBOWdWMFE3VlB5?=
 =?utf-8?B?ZlJrb2xCNlljVkF2RFduMU9yMy9KbEQ3RVFKZ24raXBQMVFTMTg3V1BKbVcy?=
 =?utf-8?B?QnFXL0xuNVZueHppeTBHc1NRTTRmSTlaeEpjNnJQblo3bGk4VzlEOGdUQUtM?=
 =?utf-8?B?S0NQVUF3aEtOdnMxaFNPMWtTYTBqc2pnbkYydis3RTFpRlF6UFhRcmphODll?=
 =?utf-8?B?ckVmdThKQ21qOXZOUmU0WmxrT1NUUkY2M1JSUWs1eGVPVE5IMjF2aUlUeGpo?=
 =?utf-8?B?UjZ1SnluemxvWFZ3WStpYnBhU2ROdkJlaktvTnNaZlFqRkszdmxFUEFzaFdX?=
 =?utf-8?B?dXFoTVd5KzM1anowd0N4WDFDUzNFbjdJVFE5Nk5jSFI0M0UyRXhwSDhjdVFw?=
 =?utf-8?B?ZFFCUVBGM3dOKzM3WGpoOFJnMmp2aUVybjZWNkdQbVU0ZFVWS3JOR0JWcUVV?=
 =?utf-8?B?MVdmRFNhTGJpNjM5b0NCcnk0dytMS3k0anJENkpFUURWYXJFNkRpVlFBcHpu?=
 =?utf-8?B?YnZkM1paYnlyQjc5SjlFN1JWN2pkeVBOMWVOWXAwS1dNUXpCTkhTcm1zQ3BC?=
 =?utf-8?B?SGRyek1rOWRKR25CaDZRWHN1d1NEVStCVU1BL0R2NExud08rZ3h0SXpQUjFL?=
 =?utf-8?B?eklkSVZ6N2ZKQ2l4djh6SEFvM3AwMkhuT1Z6N3hBQzlyVnh3bmJwNk1Wc05S?=
 =?utf-8?B?UzhBSUc0VURNUkVmeUt1SGp4Ym1LRzNIaXdEZERPa3FWZWxKOTcwUnlyTjlx?=
 =?utf-8?B?aEt1ZTFIVENrbjVIUlhKdWIvc2M5ZnNRYSsrajFHMGd1ODZIM29KZ3NKeUZv?=
 =?utf-8?B?b0UyTDUrU0V5cjlRaXJHNEZjMExiN0NMQ0tibjdEMUo1QzZiS1YvUWt5dmQ2?=
 =?utf-8?B?OHcvMjlkYXQ4K05BWDdkN0VnMS9KSjR0OVJZT1YxQjZSbUlsbHA3NHhZQkEr?=
 =?utf-8?B?RWVLK2c0VVNLWU85bWQ2WHRlVWY5MlRHU2lORHc0Q3h4aStMT1BqbUZLY3dZ?=
 =?utf-8?B?eTYwMDYxY1N3WVdJbmRPcUxXTnpobFlzckJ2Wk5mRmxVbHJMZ0RUbjY5Qk02?=
 =?utf-8?B?UlB4b3pnbDBoSE84SFN2YmtVdjlQMGVYQXJRRkMzZ3BaSzltcTBhMm1xcUhE?=
 =?utf-8?B?QVF3K1NnMnUzQmNXR3J1Y0ZsSDRrcmJJWFBXK0VQeUpSSm9HMGdIOGRxQUpN?=
 =?utf-8?B?VTRYMWJtWXJKblBiRUN1VXhMYkVMT1ZaeXV3bTNhVFRrOEhIZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f396071c-233b-4661-a5b7-08db8ce199ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 07:34:38.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2sdZsm9OQVLxTRT3D+eobWd2geLs8p89JPD316xhNDZhBLmbNAzlWHqpM01CvOTFrfTOtIyWALCDLeh1eE0Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_02,2023-07-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250066
X-Proofpoint-ORIG-GUID: rvIuBTh9Mj3UR7UPZNlUX8Gxxuarh_-K
X-Proofpoint-GUID: rvIuBTh9Mj3UR7UPZNlUX8Gxxuarh_-K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 14:33, Niklas Cassel wrote:
> On Thu, Jul 20, 2023 at 09:57:29AM +0100, John Garry wrote:
>> On 20/07/2023 01:42, Niklas Cassel wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> Is now a wrapper around kfree(), so call it directly.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>>    drivers/ata/libata-sata.c          | 18 ------------------
>>>    drivers/scsi/libsas/sas_ata.c      |  2 +-
>>>    drivers/scsi/libsas/sas_discover.c |  2 +-
>>>    include/linux/libata.h             |  1 -
>>>    4 files changed, 2 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>>> index d3b595294eee..b5de0f40ea25 100644
>>> --- a/drivers/ata/libata-sata.c
>>> +++ b/drivers/ata/libata-sata.c
>>> @@ -1177,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
>>>    int ata_sas_port_init(struct ata_port *ap)
>>

Hi Niklas,

>> This is a bit of a daft function now, considering it only does
>> atomic_inc_return(&ata_print_id). Do we really need to export a symbol for
>> that?
> 
> $ git grep ata_print_id
> drivers/ata/libata-core.c:atomic_t ata_print_id = ATOMIC_INIT(0);
> drivers/ata/libata-core.c:              host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
> drivers/ata/libata-sata.c:      ap->print_id = atomic_inc_return(&ata_print_id);
> drivers/ata/libata.h:extern atomic_t ata_print_id;
> 
> It seems to be defined and used only in libata, while I agree that the function
> is a bit silly, with my limited knowledge of how the linker works, moving it to
> libsas seems a bit dangerous...
> 
> You can build libata as a module and libsas as built-in, and vice versa...
> 
> Also, since there are no direct users in libsas, I'd rather keep it in libata.

I wasn't really suggesting to move it to libsas - indeed, it is libata 
functionality.

Could you just put the ap->print_id = atomic_inc_return(&ata_print_id) 
call in ata_sas_port_alloc() (and remove ata_sas_port_init())? 
ata_sas_port_alloc() is only called from libsas, and ata_sas_port_init() 
is called straight after ata_sas_port_alloc() there. And 
ata_sas_port_alloc() is already doing ap init also (so setting 
ap->print_id would not be out of place there).

Thanks,
John
