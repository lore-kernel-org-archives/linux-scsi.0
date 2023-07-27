Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D3CC04A94
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 11:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjG0Ld7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 07:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjG0Ldy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 07:33:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DBA211F;
        Thu, 27 Jul 2023 04:33:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0sAwG018919;
        Thu, 27 Jul 2023 11:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MTNfzg7t92KvfHiyEtyMdiXLp1HEVXLMjOrVKhBI1aU=;
 b=FJSQKutPvu9kRNq80+IDCqIHEe1yPDpsaEw60Foujmsufe7kC4MpVng/+q5RsrRnOCZw
 0GyiWsau8cLVdjm59JaJuUN+EKv2Ty64PkOF/Up8JNp5sGvW+cqeOM2ZKbgAzi4rBikx
 q+TXk/2liDy3YEJtq7VeEtbyPdcbWc/PyVI3VKAVGkg4faafD6qXHymdKFVE4XN7Gj+L
 CjHmiHybRJ6/gp/yOLgFmHtsrl9SviAQBUR/6tkqfupjBs9JRLMDdyiQk5Gqcm6KCoCd
 Ocht0YEb6d9cDx06mzLvYHwBqCwzz/KH6JAjt8i+lmcKKQG2c74WUqT/Lm5uOFNFveAg 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05w3sgbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 11:30:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R9u9l2011796;
        Thu, 27 Jul 2023 11:30:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7s9k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 11:30:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xcn0er5ANirG9LdIxHedrjD7Bha+z/wgExM+YmOFwIRU+clYbDaKJfgy9C9YhM84/4wwlYqgt4fnm/Y0Y7vHxOozE8e6xtCNRHh7ewWGrz7tNXULq1rAtEdSoo/k0/akkqqsVbn4TOhTgLuIQUKKyn/SyXFOhZjkVThHw51G0IEz5gzKymBty6wIp53jNCmurNmcMuYJ+5irOhfLNMwadpc9NvrR3OHXDpnhIpOcnQnO+R0QKqzTNiQbqSU4mX2e4EFzDQDE0+vgi7jQZXOmtN/W0ihEJNnjby9yv+IqVf70txq+Xcg1mGhL0f/r2wykKpeoIyldKzX8Yo2aayMYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTNfzg7t92KvfHiyEtyMdiXLp1HEVXLMjOrVKhBI1aU=;
 b=kShM6/Nul22uXR6ZlZYdDUE9J0AFOWOKK9vT/+cgyuBIrEEYEXpKm8JnohAqvkIhDfvZUgYJYaNny6BBSZ/il+Kk0vKrAf7c50Md30XqgwqSclGq7mhUKPwDq8Ujo8Gjop4s01zoSMwnCJTQ4c4IF1ugeUZ4Y9WPdFxcoUzV8HQHL0h73EVSDz+7epCimkckV+wpIRHPzWM7WpOvS+NK4g7Q7eHSrsgRsBae+qMdq1M2/VhOM1xb6a5pVEsR8AYG/SLjgCnI7TqRhlChjqxY6MqlVgU+UZ347y5kTZ7sJwMk/iIi3c5DnI39pfiETVRZRClYepntAdzKUJULa36BvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTNfzg7t92KvfHiyEtyMdiXLp1HEVXLMjOrVKhBI1aU=;
 b=xVe4dCG2FkhzesF53q+dRxxSF8o9sQF1VagG0Kk5/Fv3Zg0lxlD28zou3TculmDZ+rKu70kOC41VdVGn7wVOl8++ahUVu17AvedbXHU/yQvKym/MG36rmvzfrp192Y8R22nrn3ybUXm3Ev4UQ9Bx20RMaWzbGvNknrQ9j7D6V0U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6716.namprd10.prod.outlook.com (2603:10b6:610:146::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 11:30:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 11:30:38 +0000
Message-ID: <cc41d37e-5dce-9381-8b47-f8c690388a88@oracle.com>
Date:   Thu, 27 Jul 2023 12:30:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
 <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
 <ZMI78klyiVUPFRZA@ovpn-8-16.pek2.redhat.com>
 <123dc4ca-88da-b2b1-44b2-791ea841572f@oracle.com>
 <ZMJNXk5MiViklCBX@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZMJNXk5MiViklCBX@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: 20366a46-9680-4334-dad9-08db8e94e71c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/o9UTF98O719POK1H8aKAS6Bj24AOX9lN92Rlu6YBl0Q1sutuvxDQ1C8K7s/kJZ48AdqRCCz6bnElXFlDWYULznDxBky/4VK1E+A86HEpb8+SC+CIQC9i5IXvff3tZ+7Qt9GnrnNYGYDd29vITrcI6ENWe7ywntqXyRXMiPAXPl7dmybo60bP7jawTjqy0HCpGcGUqKKFrwyDnmbHf6JHLLRR0j9d8CutJQmskpClYbbQ9jIoK+iJ9+uPw97NUf2LfWP8ryjY3PGDzOvKyHyQItQBRBNAxhCUjd0H8rzJbBXj95nMEZtzSAkheUpwXWheBn4XrkDLaDk56iNXxVeeJx6+5BZxdGLAqPZuWOTbPTm0lqrkaR49T5pVsdLOtrscrE85Y3YIpqEQuKfnqAE6dDSXTh+EgR3zaqnAbPnCDmgkPXdDYNFenoaD94ovdBWUd/wR3dugIN++eWmrbD6rlnB4rRttoiQsMXzgOAogrpx8LHUv4q27NcOjwQQFe/uagLDMOrOHM/oZSrBr94WpRvDDjxEAUNOeB2HVsXVClMfWLAmZcTO5BarXKItIqjTemKBbmnLvlBuS2vnfM33i7CaAhvRGYh8fRC/fjRG15vdP5MO9R+dkh1dA0P19EgMwbkARDHf0HStB94c6MICQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199021)(31686004)(26005)(6506007)(186003)(2906002)(15650500001)(86362001)(6916009)(31696002)(4326008)(54906003)(8676002)(36756003)(8936002)(36916002)(6486002)(966005)(6666004)(6512007)(478600001)(316002)(38100700002)(41300700001)(5660300002)(66476007)(66556008)(66946007)(2616005)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enJnS05aRUhHaXhKYThNKzczK3dncGE0YlNwV01HTGpFd1BIekZxbk85SW11?=
 =?utf-8?B?UmQ5L2NCL0JBM2l6dFYzNlRWbldLd2JhM1pYUkJhVVhRRU1jVDAwMjBTN2JO?=
 =?utf-8?B?ZVZMWUxZVWRrUjUzM2JDL3kxRjRzRnBoakYySGhkWmVvcDJ3UDUzdXpzZEVE?=
 =?utf-8?B?MmpvWkJvL1JPSTA2ZTNMaEtPRk9zMTduUnY5NWFPZEZTVEppK1JPYzN4ajNp?=
 =?utf-8?B?TWVMQSswVXRBZ3N5V0pPNyt0bjdBR0lFTUxJOFVsOW1pUjJ3S3R4eDBraXJo?=
 =?utf-8?B?Y0Q0Yk0zdUhraG5FYmlVd3F3RzJka2xsQUczNHJjSzdrWng3N0xyY1ZYNDhY?=
 =?utf-8?B?WlF3YVQyZTczaGpRUDNxcXAweUZ2TUYzVE4rZURtMVZhYUJQWXFoS2JGUjF4?=
 =?utf-8?B?eDJuYVpOcjE0M0lkdWM5SUZHdWRlUEExYkdJZE5vUEpQZTZ5RlJiRTRUWmI3?=
 =?utf-8?B?WkZqK3MrWlZLaGRUQ3o5QmhHWHhlZThSRFlIVC9oa2ZXVDRSNGs1WkZDN2oz?=
 =?utf-8?B?ZEJZdFN0MnRQVytLR2tvWm1mZUNhcmg2aDZLVitXZHpRZ1ZOcC9uTlJleC82?=
 =?utf-8?B?Wk0wa0NkVytGSDJJZkpFNkVrbFVzVFZueDB4Um5VdDVKeHFVUkpXRTZ5bUU1?=
 =?utf-8?B?T2F3Y1dtdnNnZ2hTTml0QTBKQXdyaTdydllEQndwQnRaQUNvZnpxRmozbHd1?=
 =?utf-8?B?SG9HVFcvc09laG1HankxYXpVVTh2UHFLZDB5akZ2YlJvakMvbnBZcThuR25u?=
 =?utf-8?B?d0hzYUh6aytrd3R5ZHAvWlZKM3dRaklkN0xkOFBOYkE3N0NxV2VSMjE4VE1x?=
 =?utf-8?B?SUtSWUlkeGEwc3R3b1RFdHM2REp6dGJQZGFMc2hzN3NlR3ZLeXpQYll3ZWQ4?=
 =?utf-8?B?KzNhc0Rhc0ZxNUtzNS9lbkhFTWh0eGlyVFA3ZUlsMzV6SXFzYjBpMzhERmxF?=
 =?utf-8?B?ZEY4MGJOdFNMdis3eGc3dllDemVxMUhGblFvbFVpdWhwdHlkUm9NbSt0UGVn?=
 =?utf-8?B?SjRLendENE5MeURUKzFSeHNqbFpyTDQ4a0ZtM1F3ajh0ekd6R3JsUWZZcTha?=
 =?utf-8?B?RE9obFRHWmVRYisrMXY4V0lxK0hFdUoxdzQ0UHdsN3NieGtKL0dQaWF0bC9X?=
 =?utf-8?B?R0g1TkJMVUF6dTNVS2dUcGpTZkJjekcvdzlhellFOCtxaWMvTjUxZFdVTTBT?=
 =?utf-8?B?SmlqVkRzd2NOcmhOQXhtaGo3R3Npa3hPM1E3VjF1Nk5EamVoSi84S1RvbFpL?=
 =?utf-8?B?bUgrQllJeFRvSmxEZVRNWkdVYlkzM0QwV2RsZnQxS3FiL0ViRjI1Y2prUVpo?=
 =?utf-8?B?bUdNTWZ5V1pvVElGb0Frd2JwckVwenEzVUJWdU5TVEpQUkJYV01wakpBTHVj?=
 =?utf-8?B?YVZhMUgwalNpb3ZHTU9iS0g2K0NQU0FzbmdOWkJsRXVtSHpOUklOTG1oN0JZ?=
 =?utf-8?B?U2l0eUJpaHArMnl3T2NVWmJraHBDSDh4K0ZKdUlKYnZWUWxodU1TdmR5NVBR?=
 =?utf-8?B?bVpyWnRYUUQvRmRTRm12emN1L0dwSmlXRTRiN3RhVXFLbjE1SHN4bVV6WXpK?=
 =?utf-8?B?ajBZL25LK3E4VWxORDZ0NGk1UmVYeWxvbHUvcHJlUS9iTU5hM3ZYeW1MUzV0?=
 =?utf-8?B?ZG9qTXNqaVE0RitGMmVFWUJHRHQvc2NpT2FUU0pRL1RVOFlIK3ozSWdUVXZI?=
 =?utf-8?B?eTl1OW1TZHdUcEhXNGo5VllVcHpMeDFYbkdKSGU4amJaSXdxdTB2UFEzcFFx?=
 =?utf-8?B?WjYrR0tJSlNmb1NYRndhNlhsMVlQd1R3MUhEbzgyZnkraGFKZVRiQW9JWkJk?=
 =?utf-8?B?YU9UNHJIcEMrTWYydHFTUEt5Rjd1WnRaaS9CWnFrbkZma2k3OW1MV0FVOWo2?=
 =?utf-8?B?dFVKNFhPNkxJdDRDbjJnTENNQlkrSkdXQ2hHbjhPQUNlVE5RMjY2cTFrLzdL?=
 =?utf-8?B?VUsxalVZcDhBQmxhbzNCeEppNWxJNXBHVG8zTzlUd2xFdllTTnhZb2ZEOHV4?=
 =?utf-8?B?Y0ZURW5Mb3hDNnFkTUx2WTFpWnh5emhQY1FQTWJPY3FBT3dLRUhjWFlrMThR?=
 =?utf-8?B?SFRpS1dweFZiK3BiUkhYM0tHNFhsNXl5cUdhclVnVEJ2VmdzQjZRYXp2V09l?=
 =?utf-8?B?L1F0RkNXMGZyT051d1l5OFNXbkMrY3FpQUhFdU5kQ2JxbGU0OEtGckwvWFBx?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VTZVTFlDZWRHancxdnU4aGQrd3F0OVg4OXhBYTZlM1ZxakIrbEE4RldEelJu?=
 =?utf-8?B?VjlkNTZEbHFlNmNHZ09lcys0SXNuQ0pUdTdYcnowV1AzZ0hsT0tCMjdoQ0RU?=
 =?utf-8?B?ZnJ5b3BUWXV1RzJyb1I1VWRSekNMZCtFSllGcDV0U09yWlRnbnJCMzhrdkdW?=
 =?utf-8?B?SUtmU2NYVjVBM3NDUlpQZHFvU2xreC9qVVVaUGNrK040N0xQcm1FUFM4TmVH?=
 =?utf-8?B?ancyRElFSi95YWhXdWswS2lrVmRyc0U1ODJITHowRDVSbTlHb3RXRHZaamVj?=
 =?utf-8?B?UFZpUVFyK09ZZFR0YWdUaFVXOEloZmtHTWRXNDZjWVpiR1ZJazFkNWx1OW0x?=
 =?utf-8?B?ajBuK09xMnpzU0VnY05FZ093cHBuM2xhOEZFbW16WW8xMDdpRU9TZ0Q3U2Jo?=
 =?utf-8?B?U1FzQXhRQStwTlZIS3ZwSG14WGxWYVhBVkhOekU3OURpSkthTWZGUis0YjVo?=
 =?utf-8?B?dkcyRXJhcEpLSlFKYVl6MlU2VXNzN0lkdWkyajFDSGJPYm9INHFWVlpPYmNk?=
 =?utf-8?B?dUZXK1R0bS9YMHBPeFExZVZJZkx0eTl1SXF2QWJxVWFaYWU1RkNyazlOaWpk?=
 =?utf-8?B?SUYvRVlIaGNMYm90UDQ3VDI1SlFRYlhKaDlrRFk1T2M3THoxWGhXWXhiYWNS?=
 =?utf-8?B?VVZNai92RDAwbVBhWlhkRXJLRFYzVnNrSkVxdUgweWdLVWZVTm1GQmJOSFBC?=
 =?utf-8?B?NlB3aUZyTU4yQmxWQmhST2R3V1JmYUhKc3VxS2FacE1ZT2Fwa2lYOE9qMHNC?=
 =?utf-8?B?c1pxa3psVGdTTXRrR05pZ2wxd3pGYW04WjJxUXM2WUlBbFVMOC9ORmRpUE1k?=
 =?utf-8?B?THRhRFBoY3ZtazkvMUM3NnVoVlJ4bjdZNWJnaEhFUUxuNjIzZlpia2RCNm5H?=
 =?utf-8?B?U0hSWFlPY2lxS2tIQ2p1Yy9aczBCOTh5aW1wQkRZbHNuaXdvTXlaUnB5bDlp?=
 =?utf-8?B?bnBvbnRKL24wYTlnRmNVbnorQmNYRlNuWmFlQUIzNGdyL2dJempScitkMnZS?=
 =?utf-8?B?aEg1U2dtSG1iZ05EbFpWQUJLV2RvYzBjaFRFcXZOaTdXV3VwRjNqV0VHWTNF?=
 =?utf-8?B?V0NwZHVDYmZlSEdKMWRxeHdsL2RMcmxPMDFyUngrTDdWZW1xaUFDc0hCVnlt?=
 =?utf-8?B?Nk9UTTA4TmRlSWJ6RFVTb0lUbm03N0hsVkZhRnU4TXJJSVpNczdRZXdtR2Qr?=
 =?utf-8?B?Vi9ocnBFSTU5SzFBazg1N3RHeUF1TzBGMVRHblBvTTRNb2FnT3dveHNvRGdX?=
 =?utf-8?B?anR5dXFYb0thbDNxc0FQNU5xbXQxM2pZeCtBMnpkVC84R04zNFU0QldMN0oy?=
 =?utf-8?Q?hWGIy+vv7fI4riWqgW4jS/rdyLnfFG4XHe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20366a46-9680-4334-dad9-08db8e94e71c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 11:30:38.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6uA22kceV6NmqO9v4bO03HHR8miYKbdyRPGq1/VkzFTWJkRQ8EXfPanbvfRLHLIh1Sv/3BppZ7XmgNTu9WvMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_06,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270102
X-Proofpoint-GUID: kygVf_vTE08r43iaPEBWKlh8QPKwBe8y
X-Proofpoint-ORIG-GUID: kygVf_vTE08r43iaPEBWKlh8QPKwBe8y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/07/2023 11:56, Ming Lei wrote:
>> As I mentioned, I think that the driver is forced to allocate all 32 MSI
>> vectors, even though it really needs max of 32 - iopoll_q_cnt, i.e. we don't
>> need an MSI vector for a HW queue assigned to polling. Then, since it gets
>> 16x MSI for cq vectors, it subtracts iopoll_q_cnt to give the desired count
>> in cq_nvecs.
> Looks the current driver wires nr_irq_queues with nr_poll_queues, which is
> wrong logically.
> 
> Here:
> 
> 1) hisi_hba->queue_count means the max supported queue count(irq queues
> + poll queues)
> 

JFYI, from 
https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1620/Hi1620AcpiTables/Dsdt/Hi1620Pci.asl#L587C25-L587C41, 
hisi_hba->queue_count is fixed at 16.

> 2) max vectors(32) means the max supported irq queues,
I'll just mention some details of this HW, in case missed.

For this HW, max vectors is 32, but not all are for completion queue 
interrupts.

interrupts 0-15 are for housekeeping, like phy up notification
interrupts 16-31 are for completion queue interrupts

That is a fixed assignment. irq #16 is for HW queue #0 interrupt, irq 
#17 is for HW queue #1 interrupt, and so on.

> but actual
> nr_irq_queues can be less than allocated vectors because of the irq
> allocation bug
> 
> 3) so the max supported poll queues should be (hisi_hba->queue_count -
> nr_irq_queues).
> 
> What I meant is that nr_poll_queues shouldn't be related with allocated
> msi vectors.

Sure, I agree with that. nr_poll_queues is set in that driver as a 
module param.

I am just saying that we have a fixed number of HW queues (16), each of 
which may be used for interrupt or polling mode. And since we always 
allocate max number of MSI, then number of interrupt queues available 
will be 16 - nr_poll_queues.

> 
> 
>>> So it isn't related with driver's msi vector allocation bug, is it?
>> My deduction is this is how this currently "works" for non-zero iopoll
>> queues:
>> - allocate max MSI of 32, which gives 32 vectors including 16 cq vectors.
>> That then gives:
>>     - cq_nvecs = 16 - iopoll_q_cnt
>>     - shost->nr_hw_queues = 16
>>     - 16x MSI cq vectors were spread over all CPUs
> It should be that cq_nvecs vectors spread over all CPUs, and
> iopoll_q_cnt are spread over all CPUs too.

I agree, it should be, but I don't think that it is for 
HCTX_TYPE_DEFAULT, as below.

> 
> For each queue type, nr_queues of this type are spread over all
> CPUs. >> - in hisi_sas_map_queues()
>>     - HCTX_TYPE_DEFAULT qmap->nr_queues = 16 - iopoll_q_cnt, and for
>> blk_mq_pci_map_queues() we setup affinity for 16 - iopoll_q_cnt hw queues.
>> This looks broken, as we originally spread 16x vectors over all CPUs, but
>> now only setup mappings for (16 - iopoll_q_cnt) vectors, whose affinity
>> would spread a subset of CPUs. And then qmap->mq_map[] for other CPUs is not
>> set at all.
> That isn't true, please see my above comment.

I am just basing that on what I mention above, so please let me know my 
inaccuracy there.

Thanks,
John



