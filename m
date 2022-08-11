Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5995C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 18:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiHKSW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 14:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiHKSWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 14:22:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF896FFA
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 11:22:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BHsOLA007165;
        Thu, 11 Aug 2022 18:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SgTJ+RfRzhD1LK7H1SpvhWl6QCyjak9ENtinTJfTLyY=;
 b=pWR/GTH5F/3kgFbwyd7/Q6dmENZ8aKFdZkC79wi+HRXUIOY+cxmVYp/5Gx9WpGnoXCP9
 un3RJI3/QvwmEccYx9n+LjGBKi8/JI/v/5rl8cCU5ZiJ9H3GAHs7eF4rSYrcakycoDef
 5TIyq59xIEdnz6XeQiEKC9a4guHCrWm+I44FCv49p2Grch7AuNsZe9OrMjmIs42T9VqL
 uQesfzWAlxBXdeDOvdvxhsOKk1no37arRuhXx5JRyW81kz8JBSJUlW33C0zaoukUHrHV
 1a7ttrCKiYuUedhwUkYSXqo6aUi/+WkCweej8mMjPdNs/LAno3yTzH7gZulz9kZL+bEP PQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj5fah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:22:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BIChjR035319;
        Thu, 11 Aug 2022 18:22:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkc4mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 18:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5Q4tgGR1iGD+V5VnCSjo31W+UbLDYuhkoGPfqndzLnYcFyI6gXiv4xzpKzpo5vJclEsEdzRzckLef2w+y8sZfw4TosTW40m14aYHtlsLEHqPlqz0ozpOyB/ZzWud1TmCYZIS+BmE1Iu49FffpmOUFNCff4WiJ+OlJDNMlkvS9nLS0gQBMdT5zM3y5SEQm8MJ1mhFbhRuzbzJ1KO4KrxYonpkrxj3Bi8/f6n+WIoFST0+ySoGONYM/ui6ZWLJT41TXLww8gva0iLWzdhrW5m847ZeRGaJZlbc+d5oBE9BVOXBwdM7RP3WdQT+qGT5Nv/ACXTUF7Y7n6JR14xzkTHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgTJ+RfRzhD1LK7H1SpvhWl6QCyjak9ENtinTJfTLyY=;
 b=Xg1tmh5ic2qVTt58qssdrAzRCUKJNy5a7TmjEBg8tQEIlzDXYBEw4uzhlEc8Ysm47XMDTbWGp3MN9d0zdYO8uydUNtNSlIeAKDFoFbz0gLEwl4/EHntJ5vJgL4XWkxQ/n+D10u8jtVbfB4a7GX6TAXPNZWrLuv/qBuD18D0PsMtt185VwrSngt9zoyXkCuzjZH0Xfl3gF3Czt0eJoSXzaTONra+DdP1LTBzklez6S4S+GOtlGhWDHfUXOzIRQnYEC4ZEYDAedQ3GP4WIrdfzd835bvAuTJMaPkLqj52wSMsD4kxjbtA+zYGT/JLUE8/L+xa2HuWgKN4H6RrwhUEw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgTJ+RfRzhD1LK7H1SpvhWl6QCyjak9ENtinTJfTLyY=;
 b=ty80diqRM+XmRS7yoF9i6nZOvSqegcqlDCogIXeE8x+xQGmNgpH/wEziChp4oZ/f3q2P8GJ+gDHsPCOl+Jp1bK3fgJ2vNnDcDS2Y9GzWhJDkbYFKqFxBccm5Ti7ZH3jE4Ztq9oiDMvPf3fRLiW236/YOt9GgIF+dnNFLkc1Zgow=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 18:22:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 18:22:07 +0000
Message-ID: <06191b89-1825-9b2f-0d05-e8add30f2adf@oracle.com>
Date:   Thu, 11 Aug 2022 13:22:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
 <20220810034155.20744-4-michael.christie@oracle.com>
 <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
 <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
 <e4dd855269b2efb2e2f3efdde92f1f3339159878.camel@suse.com>
 <e7318011-ee9f-05ec-eb87-1d95f4fe12e5@oracle.com>
 <29f24bf21ea98082b7709e067cb2d08d2253cab8.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <29f24bf21ea98082b7709e067cb2d08d2253cab8.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0013.namprd17.prod.outlook.com
 (2603:10b6:610:53::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bafb1ab-a599-4b8f-c314-08da7bc66603
X-MS-TrafficTypeDiagnostic: BY5PR10MB4164:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOr3+VK0DOE36o4LF2YGUporsZmsEzRMA8buWyHLl54inhqWHLv4F9uKymY8EuE+lVdIRMx15Y3jcT5E8bEU9W5yCpjplgyd9pvGbd+h7u8WwGfrqLUIucDRKhsvMciTubdGBhFtr0JIwOIlmbn8TZS3k9vmxIPBjozfxshKMtcpoQE+qh/n84lAtnpfcoNHfrAUJWVpKWEfBbkzf1Ip7777vZE5YlTnWbCjabZ2d3V79TkQ/ulzaZbBj7TVH+whYSCaahsof18t7SJzaYnnD3aIgNHC1QSKRyUsda3AKZ8fZlDGonifJYyYsKuhXTJHYuCDO6BqZcMqcfXBtMymFKVqDpZTqKg/Dp4xhRwGhMi+9/GD0TyIORoNzcr6JWqFm1lbWDHWXlfEREx+/EkEnaB0z/EWdCLMtHhV6EjEAcOnpLjhshUfKy4/GMq754S2pBZecHKr4SkWbWdKKO0b41O5FY4N0gPBIBC835BvVvWOICGKFjmKLZbIsQPLSNEVptXNMtyRhWHzW4R2UBwML+UHGC71PtN2+o/OvdfMqPdTkahwv71OnkghzXNmRpo5fVQi609NgeeHvq2wD3rxH0DBwp+kDZe8czuH/HQ9JEiXgicClZJCDkZsKOJ/++X6fCtX+xqjBAbDHYLYZbhRu3JVX4zTEDv6PVQ4LO0VhnBbsSwX1/ElTf8wqVVm+xaA4KFP+LmeXAuCBUhMTUKNFdMVDh2Wk4iM3NQVP4VPhYfHR/1UGKea03GyY1nmjdN+O3iJvqo7GuXhv0quzQoCtSuri3P4xnEWcHk9hCu/90+Y8DiI/OyiNT9LGfuQrdElXps+SUS5z5bltWH8yIPrXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(376002)(136003)(366004)(5660300002)(6506007)(53546011)(41300700001)(26005)(6512007)(8936002)(31696002)(86362001)(316002)(66476007)(6486002)(478600001)(66556008)(66946007)(8676002)(4326008)(2906002)(31686004)(36756003)(2616005)(186003)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlgzZWhScFRLemJzVGpoK2VjZmtYRjJ2MHZtZmVIa0lObHcrSEhEMnJBMmdX?=
 =?utf-8?B?cUl1T0d5c1VOb1M0ZS8zSlNEdFdvNGFmRXFGNzN1dU4vWWJKNDFVNkFjUDZI?=
 =?utf-8?B?VzllMzlpYXVJelJwTzJXYWNYUlovbi9vNHlGcjlnd0o2R0lzcHlFaG1JVlZQ?=
 =?utf-8?B?MWF4ckJyUlBjNFErOUdrK0VqZlB2T09tMEo0SS9mK1FobTRUSWc5OW9WMzNx?=
 =?utf-8?B?NTVEc2lGRUtucDRIWHdVbHRjUUFVNFlycWx6NnhMTDRaZ0NGMlFsYVpFZk56?=
 =?utf-8?B?dmZwV3JwVzNJa3VQdDNlWFB0ci9NMHJaaHZZWDVFT2k3OEJ1Z2s3MEhpbE1I?=
 =?utf-8?B?VnpDcGlyemJ4aTVjVWMvMEJRZ3p1M3V5SlQxK0p0bHZwaCtacy9TaHM2WGhq?=
 =?utf-8?B?N3JlSTVHczB1ZmM2bkVoMGQvdGlWWEd4MnRNaGVDS1N4aGszWEFtR1haTWds?=
 =?utf-8?B?K0J4OXRQaFJDbUt4ZFU4a01ESmVIc0RRWGg5TW5KcFJDNUJLTHFDczRMSXhY?=
 =?utf-8?B?aXJSOXhKNGp2Zm84Q2c2cWNZcjVoZ2VGM3hnRVlzakFEZDdoWEhEQUticjhD?=
 =?utf-8?B?NGFMZ3dHU2hlNVlhWHpQRzZrT3dyWmxPRnNKTWpIYlJyUEJVWG1Ra3FHYzRF?=
 =?utf-8?B?bzZwQ0RLalhmV2lXZXJDTmZaR2FQeWsyN0hPSkpxNDBSTi94QVQrVkJPT2hq?=
 =?utf-8?B?bXRLZUIzQUg5VTdpQkFoelE1eWxHbnFkK2lXdllkeDBzcG1aV1RIOTlBL1VD?=
 =?utf-8?B?OEpHbTNlVzQzNHVJM0g2QjFNQzVWYndpdWNSK1V5WCtQalJQdlV2N2dLTHN6?=
 =?utf-8?B?QytpZC9rUVY0VmhKekdhZmVNMGt4SS9pbWdyWHJzSm1CRUxBK3djVy9Hck51?=
 =?utf-8?B?S2RHQ2NNSFVWbXlvUU5FaHZ2U0F2UFl1cTliMHFqM0p4cWN2bEJZSFd4Z2hL?=
 =?utf-8?B?VGhiUWNqcllsVWxvb0FieG1aM2FMYUNsNHdINnk3M2ZwOWo1MXNReWpGQ2hL?=
 =?utf-8?B?K1dSOWFYbmhzZXprV2dmeVNpODFrNVVHcFI0NDI3bnR4dk50WjVQdUpCbzdG?=
 =?utf-8?B?Q01VVVBRNng1NGZpdU1lRDBzTCsrT2RmTkF6Y0V5VnlwMEJrUks5L2ZXd0d2?=
 =?utf-8?B?MVM4YldwUlJqbHhXUGV3WVRIMEZXVzZkQjBRVmJ6R2Q4TTkvdWE1MG1ldHYv?=
 =?utf-8?B?UE5GcE96WHdtZDJhVndrR2QrMVdtUDY0WDZtMkEyOXhnR1ZCTXJIVmNXTDZW?=
 =?utf-8?B?UVhUdy9mS1JUdmZYckJneVF2RkF3RFBaUGNpdk56cFlKWEpSU3Zma1JzNElv?=
 =?utf-8?B?R0pHYWVCclUraUxXMzJsb1Jpd3UvemwvakZLUVpxeGtrMXE5eWlPUVlBYURj?=
 =?utf-8?B?QkxFV3ppYXp1YnRzajY2NDIyMytiYmpnamhCUzdlZmVZZXp0UXlvK3VURVJh?=
 =?utf-8?B?eERkR1RsSEduS3plcGpxZzZBYzVnOXdoZU5MeHc5S1RwMnk2ZndtY0l1T2N2?=
 =?utf-8?B?aDUwc2laWFlpS2dTOEJobTNLbFRhVE9YQ01aeldVc3NUekpocG11VVZQbWlT?=
 =?utf-8?B?K1FRRFZwRzAxYk5GOFFsd2ljNzlNbmdvTUppbGcyTWsrUjBZV2R6Yk12cDJv?=
 =?utf-8?B?cDBLR2xvcEZsSmZLTTh3Q09GV2c4Y005TnJqN1ZabDNLQnpUQ2Y1dW02aGxE?=
 =?utf-8?B?aEJoUjlvVW9ZL2VVYVlkMEhKalpvVm5zOHhvcnhCbVI4VmhlRDM2bjF3VGZs?=
 =?utf-8?B?eXFobGlIWTJNQ0tXSkNQMGk3MWRDUFpvRFVCWWsvc216N05MdGd2Q2doU2lO?=
 =?utf-8?B?TlpiTWlvcHhPNnB3WGpSS2RmaldnMGRKOC9YdGFNOVJ3NkFWYjUyaG5oanlk?=
 =?utf-8?B?QkFlYkFwSUxVNitJcmFWc2dYanBOenFSb0JuSytZZnRRblhrQVFsWWk0STRt?=
 =?utf-8?B?ekxLNGR0L2lOb05ZalBUcjNCREVQSzUvTEV4U1lVN3FiREpDcytmRURQZGVO?=
 =?utf-8?B?cUJORUVUckFiWS9XWC94ZjJib0ZxUXhtZTRreWxOa0lVR2p5Tlp2RU9YQ3Zj?=
 =?utf-8?B?N3E4cmx5Y0VZM1ZOaDUreFN0REpEbm1ra0E2czFVckRTVTNBamxJYlJocnQr?=
 =?utf-8?B?K0VIdEtxSUJIWm5ZL0hJVXJqV0F2ajdUUmcxL083Q1lFZC9URnhrZWM1ZUZB?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WC9YQ0tma2RYVXJFQjYwSEJPY2NNQi9qR0V1S1J3THlHZHpaanlsem00Sk02?=
 =?utf-8?B?dUdQT0cyTnFLNmtqZ3lZK3RNMG5kVzNPd3NzN1Bjcm1idnNwYWwva3U5NGNp?=
 =?utf-8?B?WDJNLzNWNC91V1JDcEtwaUF1M1VjS2tHUUxuUEpmTTVvODArNGNUMWJoMGdG?=
 =?utf-8?B?T1JpWm53UHh2Mm5JanN6VG9vRlNzVWV2YjVMM0QyUDRsaXdwY0RjR0YwUCta?=
 =?utf-8?B?VzhLQjBwbDhsdnFlaDk4RWFMS3RONlpvL0x0ZlVQTktvRlVneEJQMEp5Qk1j?=
 =?utf-8?B?MUVDMkdrNDl0YStZQmlCVDh3VE5JUFB1NHNtcXlybmNSYm9RRXFrUUxDVktK?=
 =?utf-8?B?Vm9OZDRaUndGOXc4Qjc4YjVKUk1sWWRYUGw5aDl6R1QrWjRxYnFPOERHb2xE?=
 =?utf-8?B?STFoYWZMc0NuZVgwcmtGbmxpLzJvdUFqc2xINUZjeGtnT3ZaOFZST011eitm?=
 =?utf-8?B?cCtoY3hXUEFnMC9rbC9Gd0hwZEhNbytFSDVzcjI4MkpKbTlwQk5uU2c4N0Vh?=
 =?utf-8?B?TUpMcVRJSEhjV1VjWWEvT0ZTTVhXU3U0S1hScUk5MmNyV1hYUk81WUhGS2Ny?=
 =?utf-8?B?aWIwL2ZoRVQ3WFZoMXo3TElFZWQ1N200a2N6NnZvcmU0a0JqVmFjNEFYZzFG?=
 =?utf-8?B?VFVYYnI2YU5yNnA0LzhDZlphdUpCa05xdHFXNFJtdHNQcXhMTVVubkxPZ25L?=
 =?utf-8?B?MkVUK0haNVoreEJSemYrbjE1WUQzNmpMQzEyQnl3T1pjTUdWbjZ0Y3hMWHQr?=
 =?utf-8?B?RUJnTm9oVDRGYTlDNWNnZDBiQTg1bHYybmc1VVlmMGhpYU8xWDZsUXJlcUdK?=
 =?utf-8?B?dTR6RUZ5TTc2MEtVTFE1VzM0NHhWY08xR2R3MXNJY095QjNROFNIU1kzZDZt?=
 =?utf-8?B?djdjYWN2aE15Mk0zcVhUUFl1Ykw5Q205QVJyczV2SWJVRHlYcE1ROWI1R0VI?=
 =?utf-8?B?K2lZdzZSMFNsV0dQWElDRFdGOFVYcnI1NG1EMkJDRnhjMS9oVW5lVVNEU09T?=
 =?utf-8?B?N3FsNXd5M0d3c2NKaytRbm9teFdFMGJydGpJc1E2YXVyZW9kaytMN29FWUV0?=
 =?utf-8?B?NmUzQkxScWV3a0RuVEpUNE9LZGp1TmN4SEJsVnBxQmVWNlI0YnRudE5CUDhO?=
 =?utf-8?B?NWlTeW9yN2VYTUw4UkZQSFgxS1hyWTFtaGkyYVRIVXVwTlRVdDQ3dWFDMHZP?=
 =?utf-8?B?ZmFNcTRPRU1ES1pUcTc3Z3VoeGZoZkVKUmhpTmVqSFU2YWxlZnlCaFJSa1ly?=
 =?utf-8?B?YW5pUXlsYWRIVGh0cjJSN2NqRDBYbVd1bTViVnB0UE9ydUF2dXB4UTR3R1FU?=
 =?utf-8?Q?qOb3rRvi74EZUgQjkPgDd3RiAE8t+oYfIN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bafb1ab-a599-4b8f-c314-08da7bc66603
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 18:22:07.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVAlVHodgkVFCnYFbs0xOEdR9JdAfAlFOtejXB24tlpVUeExXMz7OEuG3Vf28juG/SIz/7orLG5Q6hRf8MYt4Lyn42U/g2mQUQ1ATGDHqlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208110058
X-Proofpoint-ORIG-GUID: iyCUB4BqlFnPxH04YT4a2zKG5ajYXAn6
X-Proofpoint-GUID: iyCUB4BqlFnPxH04YT4a2zKG5ajYXAn6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/22 12:02 PM, Martin Wilck wrote:
> On Thu, 2022-08-11 at 11:15 -0500, Mike Christie wrote:
>>>
>>> I don't think it's _that_ speficic. (retries < allowed) is the
>>> default
>>> case, at least for the first failure. REQ_FAILFAST_DEV has very few
>>> users except for the device handlers, and NEEDS_RETRY is a rather
>>> frequently used disposition.
>> I'm saying it's really specific because we only hit this code
>> path that is causing issues when scsi_check_sense returns
>> NEEDS_RETRY.
> 
> What about the other cases in scsi_decide_disposition() that jump to
> maybe_retry?

Ok one exception to what I wrote. DID_TIMEOUT hits the
blk_rq_is_passthrough test of course :)

The rest hit that check condition check and are retried like normal IO:

scsi_noretry_cmd()
.....

	switch (host_byte(scmd->result)) {
...

        if (!scsi_status_is_check_condition(scmd->result))
                return false;

We get to that blk_rq_is_passthrough for DID_TIME_OUT because it
has a goto to bypass the above test. The other host errors we return
false above and retry.
