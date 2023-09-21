Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71E4E7D0A0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 17:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjIUR2e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjIUR15 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 13:27:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483BA171E;
        Thu, 21 Sep 2023 10:03:31 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38L9Kdbh007915;
        Thu, 21 Sep 2023 14:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=jr4mGo0dkvcRl3Dy4dNM+fpsp1+U0VX/J83WQ8Zu1AI=;
 b=wMLNArHNkmAaqCIQ2ryBWvAyds+ekotlk9CfO70INL9eB+AU6aODOokPzNiu05cz2YDa
 EwFkZi3prwDKGMhyNmezBS0W3WXZ9crJRde+E8obSJgknqcI/FUsfNnEcQxxxWmy4LMu
 F0g0RyNxe43/w8u0+hcTKkdcTyOZjOd1vMWRvZg5qnqoJrNITNZJ/d35WFv5mVRK6/Ea
 E44xDPa7dbf8NJq+Hwu6VlhRwsXeQkRNflPS1r8frU+ydmhJ65NCYXwFSY6LRU6MlN1P
 gyGba1cNk7gBzeyBF2i3sM/wgjiaOsr2UndNpVOYrwMvv0p0T7hIIHKRCzGcNyCGwoKs 1A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t539csycd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 14:16:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LDjhZV002041;
        Thu, 21 Sep 2023 14:16:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t8d1fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 14:16:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJxcmvxKJ4JvUlC8H77xbeFCikYHhP8z/9FIV+o5B4mWVTFq5RDCeQN1EwyF++a/n1uJFy3DlkInfeAlp5C+t6zvYMQul5iHynSrcZ4oLN2jailLRlzxS7ZL9Yhj1zIXC6khUj7k7oyR72fJoPH6t1TrxuuPwv5DYf4zdIIeo/8n41C9oZq4So3fYLiHEsdXpEyBuvGPWXKBzDxno/J/A8rVfTzhOQiL4PQZd5wD4kcHDrG1+dXTWPrziLenkrVEJw+gxaE9ZA+De4N4AocCX3TrSmAgPAaLgcDAmAQwXEA5lL6Z3qu3UnPhWY6UZNmnVpBBABgsrBLsp5v9sMk35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jr4mGo0dkvcRl3Dy4dNM+fpsp1+U0VX/J83WQ8Zu1AI=;
 b=KEyjR7DpCR08nvtKd6RU6Il1iUKZTG4rXyQMN3EW8EaegkMzHX/8eFhs05fb41wSLYe0xCHFFS5xamzb2Q9j7ZhVxyX54wnS+ju8lWrJbRY5X2ay0FPxmM0/Gw6YK0afkSRf8Y17QOM7KxOsQiuWOVv7ul4xMxdo7TEtICgxVZW6/XOw3qR3I7gSibXQ0QKWIctWlVedxlYORMwUH7hkfjdBcknDQ9VVlU16TWe2koor2hGZg0wR7mFq2PnGPrSKkpEuNWlx+AfJyOqz8XaZCLkflyFeKEJQlieFf6VjbS6TbsAO7MqHOadX8LakYhlpSoaWrIWJfXdRqrUWZx7AlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr4mGo0dkvcRl3Dy4dNM+fpsp1+U0VX/J83WQ8Zu1AI=;
 b=Nvsjq+MWRL232xI0J7MiKz3p1cmQnDkTEtUzKHg3AbXRGPdJsv1of5lTt7G1fFIGXoLrQ5AIcqiucHnbo1cLBpBByzUxwLGpiIr0ciqTZl1OkuTmMrcNUL3UmETucJ4pDCxfcb3zowxGkntgtLg+2UUb0jlh+ztQHSeM/R6tpV0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6706.namprd10.prod.outlook.com (2603:10b6:930:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 14:16:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 14:16:46 +0000
Message-ID: <906621de-eba1-5a1c-dd26-c3030ad7b983@oracle.com>
Date:   Thu, 21 Sep 2023 15:16:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 03/23] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-4-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230920135439.929695-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0039.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e9974e-d30a-47a8-ab3e-08dbbaad6339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTbzwNZrKMxf8fCzKGeTxb2sJz/z/6VhCuXn6TV3UHrUVBUbD6wgWVYIFRWyIRW8NKqdLTRZU+bg6M9LXLbvl6BIxIXFUzVywiED0j5JGVxomDuF3uxF8Gf+6jbTip+eAj8soNMgbwXrn8F3EALTso1BEaVqktdxcrS932CIsnER/hYRL+eByNVypOWLK0JQHmAfErpbL2puqrzmNUiJEZVsT4x78gz5kioU4HAGDQdLfSncqdQeN9KbpoMQ4Pqr6lEkEvs9iUmax1TzOdAZ8KY7I5eZCnaynm5RBd8Ypkm7v+9/aDlDDtNwKSb3yTedTcYod0HD/d8klYTPJbxsnsXFeG/7Fk3anIDYxL6bgAxCNV7vdr+3Izy8csGJRQC4GLkFYZt1GaHKkymewPo+8TrlojaG0QMyowESWg5VvXEAHVg0PVCpX8hMflp5x7d7Q7qD6uB6yWC6cmCSB2eKy3NseyYhepiCv5+ip4o/0/JvS1YR8SZbLS+8PyzqtuTiJm/kbL/fItHWRS1AFbBkEpnQRUGaxK4SirmUvg0RXgMr8Q9gp05PXqrXd1RSNOPRaB9n4qR/dnDSBHnLJ3K4qOw4PNRyLJ+Q7zckScwIl/cysRr3RK8IfDNYWdRnLaUghrvZAEgnvIoOoPjxuApWXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(366004)(136003)(186009)(451199024)(1800799009)(86362001)(54906003)(66476007)(66556008)(316002)(6486002)(38100700002)(66946007)(2906002)(478600001)(41300700001)(8676002)(36916002)(5660300002)(6666004)(31696002)(83380400001)(2616005)(8936002)(6512007)(6506007)(53546011)(26005)(4326008)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmFUSnV0ZTlYQStqdzdRWXh0dGM0T2FRdHJvTDVvSVRpSk85VTV6eVk2QXVY?=
 =?utf-8?B?OURYR2ZHVFlKWkRRZE5mT21lWWdWc2pLNnVja01pWXlFVjdZcjVrcEthckxv?=
 =?utf-8?B?MmFBYndKUzQ4Q0hEVjBpVXVaWU9ETTQzbU5xcjJJL0dXMkNFSDRsOExpREZK?=
 =?utf-8?B?RnFVT1J2SXIxbDN4RnVXSlowaWpZN2RBVlRqT3I2VG5XS3dQaXEwYnBuS1pC?=
 =?utf-8?B?Y2ZUMGlLeWZUODlCV3RsVHNrd0JmZFJuZm1wQ3BSVWhKVVI3R1MwcE5nVHE1?=
 =?utf-8?B?KzB5cGtNT1lQZlp2YnRWVjZNSm05U3VHSlpocFl1SWRESmw5SytwSXJOTmc1?=
 =?utf-8?B?K0UwN29YNnNqS1N3Y0hMaVd1STRXY0t6TzNEQXpQZTF1VzZHeWhlOHJLck1S?=
 =?utf-8?B?Tm1UelQwVXVsYU03QmJBSlRwczEvN0oyOE5YY1NGRnB3cGxQcklGUU81YkRU?=
 =?utf-8?B?RHI2VUpXR2VtUVU0VjJkVzhLMmdrSjZISXlJQ2ZJR2hVd1pnOWZobmsxbFQz?=
 =?utf-8?B?NFFSejFXNDZHOEc0MEE4RytDSGh0V3FESVZreXkrYjJOaXdVaTliQklWaVZC?=
 =?utf-8?B?NWJudkhNOWY5MXBIbHhLcHhGa3VXN3F6RjA3NnBHZmlNYVZuOGk2b1lyamFO?=
 =?utf-8?B?VXNEbGlIWlh1amxqZEVESDd1YnZtTCtLUkpaSzJRQWZQb2Z2MkZiSVhkVVFk?=
 =?utf-8?B?UDRzLytjVmVxYWZWL0VKc1FZRE5CYlNvYUdUSUpRNWpwWVlRZkFDd1ZQR2VX?=
 =?utf-8?B?WW9YWGQ4N3FacG1tbUR2YlFEbDFLa29vSk9hdFp2VXUyWnBINVVnT3ZWV21R?=
 =?utf-8?B?dFlvVWR4ZC9zVEVIMkM3SmdqTHN2UnRjdGJmcnVVT3RPWDgxY2piWTdyOW1D?=
 =?utf-8?B?Y3F4MmtWMmNXMWs0UTkvQ3ZzZ29HQk1hZHFrWUVEdkx4MDNPZE1uZ0wwcjYx?=
 =?utf-8?B?UFVNVTlJVWxtY1E0bVl5dGtWWTVLeU9xR25zZDM5ZnNQcEpIcVIvbTMwOWg1?=
 =?utf-8?B?YkVjNll1enhvRXhVdWZqZW5ldDdkbUNwY0F5Y09aQ1l1TkpSc25wRGVxMjZJ?=
 =?utf-8?B?ejVDUFBQZ3dFNnp5UG9Kd2NranExeGJySnFNdkxQYjNJcW1PWEdPU0pzTUV3?=
 =?utf-8?B?UklHMU5kVDlxTFZ0Z25LN0YwM00vc2ZnbFRkWW9tS05waEJLdnFPSVJieUI0?=
 =?utf-8?B?Sml5bFoxL1I4TUZYZ2R3TmE2Wkx6SDV6RlVmc2RTSnZ5Q0k0NEFFQWJ3SEkx?=
 =?utf-8?B?QmMzTEpVZHRZSnpEWkw3Y2JXdnB5K2UrSEIxaHpEK0orM2Vrb0RTRllLdkh0?=
 =?utf-8?B?bEI1VGtUeHpQaHkvZThPVGVZVytQTnE4dzFjWXM4TjhzLytaM2FVY3cycmNM?=
 =?utf-8?B?bEtHQ1ZTQlhiSndDYUl0TmJPU2ZGbTBDck5wWWI2ZnJSZTZnSlVnRjZ0NkRz?=
 =?utf-8?B?dzlaaEZVWTY0NGQ1WXBDMEF3Q0sxaStvWkpaTllLdythTlIyUEw2dTdNT3c2?=
 =?utf-8?B?UVo4YlVEVEpTcUtqWTFnZzdDY2xaUzRHWlQ2WlEvaElvaG4vdGZXQU53cHND?=
 =?utf-8?B?ZlFBYXkyamNCUkQwTkJzNHRGK09YTUxnKy95Tk9JbnJoYlZ4VDFOcmdqN00z?=
 =?utf-8?B?bWR3TllpMFF2ejRzcldYc1Q3cHlJQmdjM1RGdGtYb3pGNmVBcSsxTWhlcklI?=
 =?utf-8?B?aUFxM3pVQWpIUzExZU84VUoxWVg2VDlsOERlN1liVDNBbWZxcVI4c1RIeE1D?=
 =?utf-8?B?L1B4Y0diTkRHbXdiMG8wOEZmQ1lHMmlHQXVlcExYU1Jvbm1xNmVFdGI1UTVr?=
 =?utf-8?B?SkljeTFRMGRFcUlTZWpMOWx4MjFDVUZ1RkRHblJxS1NOcURiWk1KMTRqODQ1?=
 =?utf-8?B?YUlaWjdUbFJ5enMzMmtJVmNBNXg3YVZWcUFNeXB3L1hzVmV0ZlloMW9nVkRi?=
 =?utf-8?B?ZWVna21zUE1ETm9mSk9WUVJZOUlKT2x3UVVTQytzOFBrVk9paTczQ2JmVFVh?=
 =?utf-8?B?TUhNQ3RRWGkybS84dGtiejRtbzRtQmdNK2pET2lVcjM3Nkl5aGlkekt4Wm95?=
 =?utf-8?B?QjlLdW4vT3BPeVk4NTFpUTVnRWhwaTJ4ay9FNmNOLzZiVjNPQ2o1dmNTOVEy?=
 =?utf-8?B?ZUM5WmtWVStpbzRCSkE2ZDZLUFBkbUwwbXNIK0pDSXo2cjFOUFc2czZQM0RH?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TWJQK3Bhdzh0Mm00dVNPY0dLSUZnZEhBcHEybU5seVR1aXR5NVRFNmJ2azg3?=
 =?utf-8?B?Mys4dlJoNnM2TmlROHlaWmcwbmpKeHZzdDVXZVUxVHpjdU5TcFRlTWV0RGRX?=
 =?utf-8?B?cDVUUFRpaVdBNVRJK2lZd1lnWGFpclIwUWMyTVhmd1hZY0p3Q1ZJMFlrZ2hy?=
 =?utf-8?B?emhNUVdmNXFwNXdINi9wQzBTdk93djVVTjU1aDhkeEVBSzJuNExDTFQxb3dj?=
 =?utf-8?B?bzlVREdqeDhJYU1yZXRvUCtsR3JrZnVTb3BkVkI4clBNb3EzZUsxcFBRdkI3?=
 =?utf-8?B?UXM2Vm9BZ2hMT0xkaVdld3ZpNGNlZE43dXE1QU5ITkdtTHRaWk1MSTExa0RM?=
 =?utf-8?B?MkcySVNKMTNMbTV6SWtnQmM2RXRVUmE4T2RRMXRhZ0hBb2NNbkkraTY3QkZh?=
 =?utf-8?B?eDRzRzFJVFliN0ErSnZaZGtoZHlYc3VhK2FrYmRHZVpwSDhMUGM1N3B0bktB?=
 =?utf-8?B?NFR3YlYrWUpmM3IzTEJzUW9OOGVIVHhMOUdwdURnVmRNMlhJMEdiTnFzaDMv?=
 =?utf-8?B?TU8xNEd0YnNJNlpld0w5UWNoRXBrMXIvcHk2c2FJTldjSmg0N2h4OG41eTZm?=
 =?utf-8?B?dnJCdHJqODRqVno5TUViRjRrUngzRE5lMGVoL0p4S2lpWkRyNHVIQjR1U0Y0?=
 =?utf-8?B?VlNxaHlNQjNnMThwbzlDbTQ1dFprcWJyWVFKTWdHaUlueS96RTFmcldJaU53?=
 =?utf-8?B?RFd6dnNsdTRuaGd4eWY0NWgzQm01bnhBY1hFMkdKWENJNzVET3BDUm12S1lq?=
 =?utf-8?B?a0llWDI0eDU4UjRTaDJ2Rm84WWJZeFMrWkJSUG15amF6TFZDK0swUGtLOWlY?=
 =?utf-8?B?Q0t5bFhQejBoK1kyMG9DMnpHTE1ETVRxeXd1MVhXMklMQmEwOTR3SGppajUw?=
 =?utf-8?B?Q3ltbHhEV0wyWWdvb3l1dFdpUStrUDIyeVkvRWkyVWNtQXR4Z3NZb01OMW5N?=
 =?utf-8?B?Y1RMeTVpUjZwVzJ6Y3FleGFRZktjUjZESWl2dnRLWU1XUm03QnQ4K1U2eHpZ?=
 =?utf-8?B?a1UyRm5lZlJYRzM5c3M4cEJ0KzhSakRHVC9mUVZETWszeEVoa3ROSTQ2OFpV?=
 =?utf-8?B?VkdnTWhIalF0WEhxVXJyS2Zta1crNnR5T2JaSWVEYW5rWlJzUzMxck9UUjJT?=
 =?utf-8?B?SDNrMUJuUnNDRVg2YzNKS3NvUUxTZ1ZnQkJEMXVUYjg2RWhiZFN6WUF4RXV1?=
 =?utf-8?B?L21LNCtLdUw2Ty8wazIySzFWNGlvcXFjSEt6SnJVNDllbEMyWmkySWtBRjhF?=
 =?utf-8?B?bnBWWnNuL2RtN2hNbk5zbUNDa0RISXdmc2R6Wm9qVjd0ajgrZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e9974e-d30a-47a8-ab3e-08dbbaad6339
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 14:16:46.1820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOo+AfWm1r34z1gO1NMR5SaOQ4cWwHXEfShQRNH004us6X/GGneb4/922D4sO59lRWtyH1WbJPV/4kP4OHwoIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_13,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309210123
X-Proofpoint-ORIG-GUID: NZPReO034_B_sYQoFqPVm8D5r_jgbrvH
X-Proofpoint-GUID: NZPReO034_B_sYQoFqPVm8D5r_jgbrvH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/09/2023 14:54, Damien Le Moal wrote:
> +int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap)

nit: why not static? I could not see it used elsewhere. Indeed, I am not 
sure why it is not inlined in its only caller, ata_scsi_slave_alloc().

Thanks,
John

> +{
> +	struct device_link *link;
> +
> +	ata_scsi_sdev_config(sdev);
> +
> +	/*
> +	 * Create a link from the ata_port device to the scsi device to ensure
> +	 * that PM does suspend/resume in the correct order: the scsi device is
> +	 * consumer (child) and the ata port the supplier (parent).
> +	 */
> +	link = device_link_add(&sdev->sdev_gendev, &ap->tdev,
> +			       DL_FLAG_STATELESS |
> +			       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
> +	if (!link) {
> +		ata_port_err(ap, "Failed to create link to scsi device %s\n",
> +			     dev_name(&sdev->sdev_gendev));
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + *	ata_scsi_slave_alloc - Early setup of SCSI device
> + *	@sdev: SCSI device to examine
> + *
> + *	This is called from scsi_alloc_sdev() when the scsi device
> + *	associated with an ATA device is scanned on a port.
> + *
> + *	LOCKING:
> + *	Defined by SCSI layer.  We don't really care.
> + */
> +
> +int ata_scsi_slave_alloc(struct scsi_device *sdev)
> +{
> +	return ata_scsi_dev_alloc(sdev, ata_shost_to_port(sdev->host));
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);

