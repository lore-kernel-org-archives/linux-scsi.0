Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38249C05027
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 16:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjBCQPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 11:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBCQP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 11:15:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCFA0EA0
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 08:15:27 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313DMtSq028545;
        Fri, 3 Feb 2023 15:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kfZ4I00OQLYxTAzthMRNn5kiEMLVjuNNjYAe+wvANqc=;
 b=epvTAKaOeSvyICvmltmkNxoe/Ba/FGkYKTUZeclQkwba/mPiDHVuG95zlC0dnN+IsYhH
 OUJUS68DCoais3fAZQb8UZ6ryT7F7XGRXlxiKgnW2c7OO5UnvqobU3xt/iaAtFRzLRi1
 cPd2u/+IESJ40CJv04HnRqoTPua2HV7UR8UxS26my73K+4px6DMI/rS1PheAGZLH/zus
 MBw42y7lZrn3xXksMqAav/RUs606pFgDGZ7ksqeECyHsjCQnbmVMgHPDqiPw4hU6g551
 S2bOBmrpPMVuwAJJ5zOigVnh7AfUv66oIgw0cLejJH2xWx0MA6O1bEQeri5+zajKnvQP +g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfq28wg6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 15:09:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 313EYW0X030498;
        Fri, 3 Feb 2023 15:09:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5adr6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 15:09:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8GymroOIzExgr9XjCCcYqymkr4NWO26qpp7pFIX83b9B7j1b0crkTmg3UJZ6MmUCVVW3DSmwNx8+l4+fgJYFuRMED5lYg5LZXtSY/v+dkVde+qccH23v3WS3C6k8x98GQeq5omfTexaakvYvEq3s3yrvdBW9+W1iS9N3kX+M+ldDGEAyMRaJmJ+MS/ufLAfBuXT3otYcr4n22S+WiH+vluLa9OjO6yQHumgnTyqVOd0emnldTM3/ZAZWMg+lbKJdIRRpjHSdXWBkycRdK4BbVJlkkyYhheDjEvywSHCT6AZd262i9uyfZxlmMcST8QsEUc6vE+i+9KDhV38gkAfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfZ4I00OQLYxTAzthMRNn5kiEMLVjuNNjYAe+wvANqc=;
 b=JUZex5giqU9Q6UsQsP4Zks8hIqmxm/nuasNy5XLTUSEniKfkhVYMTR+88BEj8/nXSENiSm4tKcdFdzAXH5YV4H32s4YO0zDQylfYEUbINx88qDa0cqKxBzxCyE9jTW0i8s7Mdb9EREGed+A/CSGFIZJFZcwsnq52C/E9Y2x9dwZx2PshUXFKl0Ki/uShFXGsv33YffAl0Omj78dpK5CJqunQfcBS5Fv/oHFGsYQEulkI3Ppsy6SNP8HFWTC6daBT+rHWUF2hONjtTaRxJqc+Mv6L5aqVUONFitdBXRBBEWfKOp93c3+XZcNr1GJUvzbh4hsGVYq3PabQ1Sq4/tCjfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfZ4I00OQLYxTAzthMRNn5kiEMLVjuNNjYAe+wvANqc=;
 b=eHU9+/XYX8+QXXPIecDpwGpBvJbS+cGDfDn36O2fzLwQPjDTlunBGU4++7gB0stFnFQBCnqpeaSiGZ+mYJn9fSH+fCMzb/Ni4M0Jphb1B319M31v+t/QIwM1wFW5n+D2raHC4xZ9mUrWEL7ad8iLX46vNqtO9lxZ2/c29IxrkGQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.9; Fri, 3 Feb 2023 15:09:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6086.008; Fri, 3 Feb 2023
 15:09:21 +0000
Message-ID: <34096f52-253b-8df7-cb88-5c40159e78c6@oracle.com>
Date:   Fri, 3 Feb 2023 09:09:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] scsi: ufs: Simplify ufshcd_execute_start_stop()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230202220412.561487-1-bvanassche@acm.org>
 <20230202220412.561487-3-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230202220412.561487-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:610:58::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4663:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f77058a-e7e2-4c10-c31b-08db05f8a0af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkYr30uMekHnhNXLauBH2DZJC6uuJ2pmvriUP5ytcZmpKQh1DScqvq3YHLdrlwR71kQEVWq0H5Lt0vE1kM+OdWXjEnF8IlAGolcRi7b1O9Cn6oVE9wdhtTDcfqcXyESq4kPQv+koc/Vgn9GgO41r9BPchbnaveS2JgYC652xGLwb39taLjSRP1/LrtqlwOV6izstnfUeBMERotlUBNHDuePaMvXcSWaI7Qg38SxiobmQiSvLHOmGPlTOd8wfl4MjRAXUYwVkczI8sq3Z1rMu21HbkDoAMDIGDaCeYRAvgrjQytcnqH9oRa1QLfPkDqb+LMTfkO2/Kc6vbrLxu2JKIkQx9Am/K0sejczZ1VSs63qe9do0Pio/aGD4IeW3qvS5De1HSBNI3kbTWkwj7Jyz/Cgf+mIluWTQGqcXYkgRlQ+sJDPbjOiwkThjYOwpCNU4NZ92r8v7z1DJNzTuFw763ffWjaj3NEAQv01QVLZ1Kr8jypE16JESMvYauW6GPV6hAuBcMActuzRfEHJvRoWliYpsx1d60YauHDhbDiQn7cVcHj88mKNa3k7pzXND+w6KKiwneRUl9ZQH20Q+APuYyvOnDBb66zYuR1BiK1N3sculroSNcF61lk0rQroM1B2faq02Rou/SAS6gYxd4IFWuilI8bzNKPnxzCol4EEEM5n15doIsqXwUisAHNG1tSf22lUhzS42XFav0wrnQrdOut0NZTMbom08Rb85wpJX100=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199018)(2616005)(36756003)(41300700001)(2906002)(558084003)(316002)(66946007)(66556008)(66476007)(4326008)(8676002)(6636002)(8936002)(53546011)(54906003)(38100700002)(6506007)(86362001)(31696002)(6512007)(26005)(186003)(110136005)(6486002)(478600001)(5660300002)(31686004)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QS8xVUJneGpVY2dORSttNk91V3ZUSFJVS1F6YzZza1F4VEhsc1N6UndUWkQ1?=
 =?utf-8?B?ZFZSV1R6THpaTTFFaURmcVhLcXFEQjV6VTFvcEo2WGFScmpZWGtidjhITWoz?=
 =?utf-8?B?eDVXUDNRb2ZBTUFJR09TQUVtS212b0xTNC9BTFJVckN3eE5LSStGMXZwM0R2?=
 =?utf-8?B?b3B0NUFaZHV2NnJjMEhRUUc2WUI4VlBZVEFHMnVkWXJ0dWlBQzdhcjlja0JG?=
 =?utf-8?B?cWh2b3dSWlNvUmN6aHlFSGF0SnRlME9KekRhemlpVWZqMjJnRCtKUVF2ZENH?=
 =?utf-8?B?a0xMaGJhUElBY1Iyd2xEVkRtRkkvRVpMM3l2aDMzQlJ3T0dRRkJTT0Y1SHBz?=
 =?utf-8?B?eFdPZGhJV3VyUkJpbHBSZnBRNE5xblE1SXhKSzNrY1RVUjJTTXpxN2FJMXRO?=
 =?utf-8?B?R1gwRnBRY0crdFZVcVU4VERlZnpabTVJcHV5cndPLzg3TlJySVVpUUNTMHNF?=
 =?utf-8?B?Yy9Sa1o4aVZwWS8zWXE1YytSeGQ5UUkwLzAzWUVqNTFZcmlKa1EyMlZiYUdE?=
 =?utf-8?B?Mll0NVZyU1FTck5SRmVraFB1NHMrU1dUSGhPa0dUY1BGNU1zbUoyM05YUHBI?=
 =?utf-8?B?YlFEL051eDlPRDExQ1pVZGdCQithUWRnVFNsa3NtNVVtc0RDUFVHaDNBRjhR?=
 =?utf-8?B?amRxbEQySXB3YVc2NmV1Mjk5eUxBRitkSjF2Y2NHUnUvN2JCaHBPeEt0blhR?=
 =?utf-8?B?ODVPUVppbkl4a1VRdzdSTW4rL1FINHljWDg5RkRBd0pYUnZuUnpMS1NuK2dr?=
 =?utf-8?B?VzlqMml5WGdweTRlbFBtT3Zsa1FnTU1uUmhMeU1kR0JTRTJCeC9OSjRHK2FE?=
 =?utf-8?B?WDRhVHBNUVVodHc1Q2N0NDVpY3RqTzN1MDdwM1JRaVVnajEyNTZlQ3lOcHZp?=
 =?utf-8?B?ZHcvYkJiZDRUREZ1MlVxR05MWnVHd1JKdmN6MExuMnpTNm5JVUo5c2lybkor?=
 =?utf-8?B?TzM3K0crcHNsQkFKTjhVbGVScHhxUndzMG9RbnI4bzFvL0tiRUlDRlFQUW0r?=
 =?utf-8?B?MXA2cFg1SXB3WjY2M1JzcTVRQllSeGtjblZPcjVSU1YwVnFJcERjZlRCSmdX?=
 =?utf-8?B?cEljclJCOE9ZT0pRZllRcjhSbmpaUlB3UFRnc3A5akU0Sy9nSG15QWJCVGRv?=
 =?utf-8?B?M2lUVXc4Q1B0RDQ2THRBQXZiUGs4SEc1cVp6SjJNV1FTb2lMQUMvSGlHWmpI?=
 =?utf-8?B?clJDSitlOHYyOHp2UGQ2VGw2R1VjTVBMNnU4b1cyckRHV3lVNDZhK1FIWDBk?=
 =?utf-8?B?UnRteEZWeUpBbXZyOVpyTWZDVGdUK2h0by95cHcvbmRML3JNNXZNUXA0RUQ4?=
 =?utf-8?B?dzNTdW12YnFlN1pJVnQ2NmlVaWwwbHVNeDY4S3RrcmZUVmhibFhkZi9EK0Vy?=
 =?utf-8?B?Z3NRZEVPYUZ6RXRjS0UxZ2xsTlZaY1RxNXlPbGdCaDdQQk1CTGtLeUVZNWY0?=
 =?utf-8?B?a0RBWWk5N2p0Tkd6SjZldDM2MGVpQ0FvTU5aVlpVYjF1ZTZjQ20yOHo2WHRu?=
 =?utf-8?B?YnlRVE1kQUM0cmQyNDBKU0hJMmpWWTF6WmNMTlRqK1MvWUs0MDRWVHNyYWw2?=
 =?utf-8?B?WkE1KzRwcFM1Z1FXcHhkdFFJZDg2S1c0RDFrbUlEOVpOenFEYXB1T3VHellk?=
 =?utf-8?B?aFRvYzhaZnpCMTZmaThsT1FFOFVuaTVGVDRsckdqazV3ZUpVNnR5aG5wNktu?=
 =?utf-8?B?QUNydFh6b1N3cnBzU0pPUm9IYjlHTGI4SzB6OWNXcGhzMGtIKytiT3luenhs?=
 =?utf-8?B?UjlEQnlTdTE2UzVUd29mR3VSQi82aU10K0dObS9ES0UxVzRpY3J2QjN1M1E3?=
 =?utf-8?B?OXp6aHFzY2ZmMWY2SVhSWU1LMXJYdUcwa0x2cDZyMFRjV3hWWkMrQStDdkM5?=
 =?utf-8?B?d3U2bGRjNXdzMXg1WmdFWjNsN2xVRldWQk5kU0I0bDRqSmhzREtkbVIzWkk0?=
 =?utf-8?B?NzlWcVVIQWpBbllVcEVVWk92SUROMkErQzByS0ErOVN0RmphOGhLWUkvUTVy?=
 =?utf-8?B?Z0Foa01scEZ3b2pySXNmUGtqRi9TR2kyb2xxNXFzTjRpQjMrTWNCT0pIelBY?=
 =?utf-8?B?UWtsOHJQMkhSYzhSRXFFYUF2blZ3dVp6ZjdZWmdkUDdBWktIeXk0SnBuSkhh?=
 =?utf-8?B?dTZrQ3ErSlRoRno0ZUlWWEhocUp5OGNXNEQ0Q2xWR3JxQm9adk1STmZuSmlT?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b3pjQ1RhNE9RV293SjlDcjVxNTZtSmhXZEVLRzdYRGlGVDlDSmRNSDI3VERY?=
 =?utf-8?B?VTJHeXlLSTM4eWlkZS85RUlXRTRyWFVNS0t1SXBuOFplWWVVNVM3Mm5Zamp0?=
 =?utf-8?B?SkhVSUdkQXNVNkExa0VqcWFobFJtR2doVlJYTlBvRzdOUkE4VG1FSG8wOGhq?=
 =?utf-8?B?cXBySWcvYThOcnVKVlhTTnk0QWE1S1p6SVF3dzVlQnIwMFNGdm1RUzFSenY5?=
 =?utf-8?B?aEdLVGx1Tmc2MUlQS1UrRXZtMEl4YURTUWcxcEVWTW45NDIzVFNvdmRQYlN5?=
 =?utf-8?B?aFNIN0xXZ2ZPOVlsMEl5c1FzbCs5OVUwb3NYSlMzVkpFRjRuU0FKaElsK2hp?=
 =?utf-8?B?YUs4cjdodmpNRVNLQ3dvdHE5bzRNN25ya2dRYXd4eFZiTGo3WjlFRTZ1RFdM?=
 =?utf-8?B?NHJWSEI3d1F5SmVYd2ZGSTI2UjJqTjQyTTJBcUhXYWw2Zkk5aExvZnZIcXJJ?=
 =?utf-8?B?NHd3bm4rU0lGMjVWWk9sOTl1bFJuMlVNOVNvRnY1V0hXWTR5MlNKaUx2dStG?=
 =?utf-8?B?OVZLTUdxMDhmdldiWHJCU2RGKzRhMmhhSmpmZ1phd2lCakV4VVptQkJQZnE0?=
 =?utf-8?B?Q3JVb21PVE5zTGxmazB4akRVbnBFcWt2RUlFZXd0K2hIN0lBYVpFd3NINnZD?=
 =?utf-8?B?THJFMXNBZVB5MElvZHlPN1Jpdm1JRzhsa0VzMGRONDdHelpySG1VbEJYU1J3?=
 =?utf-8?B?MW5IVDBpZkplWlRySE5vVlM0d3lDdDUrV3lWMlZCN2ZvUUR1MlhnKzJwYS9P?=
 =?utf-8?B?VW5HbFhERHFXSVoybnB1U2h6dWZnQzNxb3o1VEFGZytmYThJZmYzajlXa1lR?=
 =?utf-8?B?RG5uM3VQRUQyWnpodjN0ajZBTUZIeWg5bkFSQ3ZMZDVHSTkyRkdia2FSUTFt?=
 =?utf-8?B?RlV1aWhhV2lFcXpqdmZZb3piM0V4TWZmVHgrY2NvRlB0UE9xeFBJV1JXSFRw?=
 =?utf-8?B?V3R4bUZ4OFllbUQyVlprdGk5Wk5pNnlZZkxNM1loRDRVK0xpY3VYQ1QxaUFy?=
 =?utf-8?B?QkFOTFd2a1FiVVZQNE9rMWNJaTRnVHd2Qjd5aHRTQzVGN1g3Yy9TWGVhd0hN?=
 =?utf-8?B?NlZldFdEdWtFOGhJSGNxTFRwUmFQNXk4cDFLT3pxOU9vbG1QQ28raE5xdmtH?=
 =?utf-8?B?eGVadGk4YWVrRGRjTXNWSmZibm1PN215K1RVREJEZVlCb2F4VzVLa0Q1SXpy?=
 =?utf-8?B?ZkNDZk9RSXNpV0RjN2EydWVuSzA4NkRKLzdka3NrM3orK08xd3IzVWRoZFFI?=
 =?utf-8?B?aDhRaitCZ3hjQUYzeTJEM25ObjBLcSt2WE5wVmtnL3B6dFVSM3BTcG10R3dX?=
 =?utf-8?B?UXZySlBibUdSMWJkL2N3akVOMjJKTjhCT1Y5U3NyUkhKTXNYZUxGWFNUbWlu?=
 =?utf-8?B?RkYzU3RHVDAwWWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f77058a-e7e2-4c10-c31b-08db05f8a0af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 15:09:21.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kNVmWseavhTNSAhi6A+qi1CZBBR9v6MFqLYSInVFK9axrpfVJ9V+g85XhWrKplYYwjY8WRbEHN2G/EAVxDbfICfRE0vmX70DX/f5bqZEuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_14,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302030140
X-Proofpoint-GUID: hFN-7Eq3UfNBQwqJjiv8wgGptdbE6gLI
X-Proofpoint-ORIG-GUID: hFN-7Eq3UfNBQwqJjiv8wgGptdbE6gLI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 4:04 PM, Bart Van Assche wrote:
> Use scsi_execute_cmd() instead of open-coding it.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Mike Christie <michael.christie@oracle.com>

