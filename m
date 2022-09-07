Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9233C38145
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 20:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIGUGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIGUGL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 16:06:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4817390F;
        Wed,  7 Sep 2022 13:06:10 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287ISWrJ017312;
        Wed, 7 Sep 2022 20:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RgMFBusuZjNjaxb5EsoshfNBPh2recW6tWVGcz9fWt0=;
 b=mJJf+EUizbAQqqEZ8P97qss+rCfF2M+vH2kakfnOL4DDAIvsR3dqqKB/fpGPVaSb8eGP
 cfcRnt/22Kj7ViwmTAtxVPTQOCDokYE3xgwZD7mQiAlBioWncbpwmHi6cvSYeJ+cutma
 e3V2YiN34t+O8lOJnpkT5u4PnmlTWZNhB0ZRFnWPsO98B9K21/nRYsONqPofZceO8pBZ
 jtGu5AtOj5VQAifj+1VvBrybCgpYbaPmRzjYi95qPATwkqVe6ACPRXNTiZSksRbrKtH0
 p2DmraO6TxaV95RqOsmlPsPlni9HzGbytgjFkc7VAtbPnbgrTtoKLwz5sVCMkwaErPcr ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq2j07m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 20:06:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287IxoEw033512;
        Wed, 7 Sep 2022 20:06:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcavf7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 20:06:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBOzYIc4+QQs430G1wgV2F97MVs+03XjznsKXu0e9hVYsrkFPecW9RV63K0uKJC5fC2eCD67FpHuq3DgKtG9PA7FHJ9WkGAtz6dauN2iG3gbZPkwuaDnjrQlToR9p+ZfNzIuI0VTEo3wDHWerFNr6zup9b7SmmoVu+JCWked7RfonSK6+96bS/9eIFiXAARXWQ0Y8IJWR171w/VORxCWOnV1ZPS0fIOVINhKQ1eLWV4Uwwfmh41y4KQohBCN8R5KmWYixkKDkibTwPyJs8HJzE59uE0pOktRPaSnFchMC7Ft8WNl86IOTmcEMOtB3018KPNvQnJxcxUurvdtieqopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgMFBusuZjNjaxb5EsoshfNBPh2recW6tWVGcz9fWt0=;
 b=AP5ZLPH2J9DO8K5KQye4J0UcIBIO5zfSf29PANcnzIrrcqvEWO/F3OMkujdwHKSrifqoivFbVbZ999ZeGGvxIv3LytJrUrGfq3GFtD+2PcV3qR4VKMU1sJZ4yPMwYmoEbkb0RH9bse9RUVJbLYIpNsDFo5ns63UhLxUWcR+11PX9ci3FqnDF8jWDCyQGHHKkzzesxDBrCrRpKfyECTiUwT4Eanz/YUEtC/YKBjsVLFyhe3zK9ZJGx9GUdpcw/4GsrStFPr5SwW+r5vg5BJ0FkuiIaXS/fM5wcl5idiFrJy/4GBlq8IGdIf3O6D4gq6wcZpVnTLEFveyaMAkmaljwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgMFBusuZjNjaxb5EsoshfNBPh2recW6tWVGcz9fWt0=;
 b=WACMBkWJDx98s8y6Fd2E8V0kbCY23+Cf/gU7vw9ho5XZIegoIQu1ogQja7tF2/qQy/cUdK8QyMOxKSKk4+pF4l+DdV+1wOVwuwAJya3rxZFTsrf085WUL6h+VfLh/c+F2OY4sIlqmArte332vGtezKNh37cGCtUeoPbbDnX3o14=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 7 Sep
 2022 20:06:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 20:06:05 +0000
Message-ID: <8b2da710-f878-7b80-a75a-6f7e95df3452@oracle.com>
Date:   Wed, 7 Sep 2022 15:06:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] scsi: target: core: Set MULTIP bit in INQUIRY
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906074820.18685-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906074820.18685-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0394.namprd03.prod.outlook.com
 (2603:10b6:610:11b::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 141fc58f-8097-43cf-2290-08da910c6594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NPpz4nRmsWaNWtiHSBMhrPNh1dXPY/PtxLljPJalb0472MtjcQqGJ+MJr5ZICBtpzbj0ca2VtGAghFhJQdgN6U2gjYaSkwtCmI+bg14Hhkhia2HtZWC7s6VZa2sYkRixkgwBDsM23rjZqpF0xo4gf+eeFsUqC4vAA6vpbHL7P1uyccqYnjV9GnlCAmZX7pLxzQRb9FRlII6nQsT0uhFfF/PPBQM9yln6KrHncgBdMC+j0QHWiOziTtU6Rz+tuy+aW+zO+lBP7BY36iH67E0kxwKOL6+QWLi1k4KBu/Z9wA5PBaGgFZCdXWhrrEqwq25wXB3vC4b3yM+QCUcNfCfHa1MbeXFOJuMapJBtTQCiiAH2ZTqJjJhViUF9EDWkrvgVsd2ynuzBTEEkVR3gvxkuLsxCxiADAlNsUckn2Bnjo5puH98iW49zNIyQwYiH7KNffgwf1tkoNDJgrCHXMknEiMbFWDlkVzNaqMIdwqYC5ZslClRObFDYA3AllAw118coMdaBMnGQHfzCs98Y4+MNkeogY9Gt95R/7PzCbYy1qQAAyqXzrVqBDBYBCuYF5Dw3DJg6tH+52Zi+dGa5uKwBsAxOpFiwvQunnHGE7W9uw0ArCWAqbjDco8nQcGYE9Kg5p4BlgtqqI1ALHC88/WxZX5Xtw26ROBt1WJjNsZNs8+AmmE+DKA7nzf9kTT/o4/G2rsuinA8jzB4o4wHJ5kOQ5UXB4e9gi3ryBwnHLuEa6i17t/XmCcrjXHkVxzNCYeD0HUvPDVNUs9JGI81tsgeirQuyhVLZYo2ih/AlD7ZV+U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(346002)(136003)(8936002)(5660300002)(38100700002)(2906002)(83380400001)(2616005)(66476007)(66556008)(8676002)(186003)(4326008)(66946007)(110136005)(41300700001)(316002)(6486002)(478600001)(53546011)(6512007)(26005)(86362001)(31686004)(6506007)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTB0MDRXL3djenNid254OWg1aXZwczM4T0VxMGxkRERWNVVjZG4xNGFOMzhm?=
 =?utf-8?B?Rm56OGhvS3dFZktkQnQwVFY1bXhZS0xtZ3hxZVZJQ3YzR0xOT1BYclo5SlZj?=
 =?utf-8?B?T25SOUZlblliL3lzM0MxbEhCU1hMSjVuVE5leFErY3oyUW4xbENsczRySndW?=
 =?utf-8?B?aUwrS2Z4RmFnZm9VTG80RWF3ejFBTmdHaTJtUzRtc2dpcm9mSjFaR1pLUTBh?=
 =?utf-8?B?dGJ6eDZFb09ZMkJBM2o0dWo1RnhXdXd2ZjdoR2J6WFpiY3UwWFFTeGFnZFk3?=
 =?utf-8?B?T0NyOTRteUF0OGpXTnRZQVJ5dWQ1cUdtM1lqQWM5bG5maWRKUUFVanpaclQ5?=
 =?utf-8?B?R0FVQlI1VURsMVlSeVg5UVhiOG1uTXFrUXBUSjFCWU5xSm5SRW52bElyWXpY?=
 =?utf-8?B?TVBuREh5VmpyT0t3czRiL3NnTTZxaksvRGxpcEhFbmR2TFRZMFB1dGtRZEw1?=
 =?utf-8?B?a2lSNi9CWTZya1RtZXhxTGhyVGhLZWpBYmI1SmZ0cFhlVm9SdEZ1TXdSaUpK?=
 =?utf-8?B?ZHZhM2M3OFFSTE5vYWRZaEhuRXlzbmJSM2tDSzlPNWtndUx5d3hmUnNBSjhT?=
 =?utf-8?B?YUxOZjltTzNZdWFCdTA3aEp0ck9hbmNtRUQxZHcyR3c2aXJpNkNmbElGQWE3?=
 =?utf-8?B?YS9JMzFha2pFVCtUSjA3d014dDd5TEM0VDRacWtCYzYvZVdFQ3RmcjU0dFF3?=
 =?utf-8?B?Q2tnTHNmVDMvbkw0T3VTcUVhTmlNVjlDclM2VHhlVzUyOWw2OU5yMkcrbzlm?=
 =?utf-8?B?MjA2NmhMZC9iQ1BWYVUzQXZ4cU1ZV1lDZE5pblE1aFlyREhoWU1OQVluRnhm?=
 =?utf-8?B?UTY2OXIyQlQzY3Z2LytXMUtNYkRPbjVuN1JJZ3lBbm51NHF0eSsyZzJ4VGFw?=
 =?utf-8?B?NnJwL2VUaWlacjFIb1RaR0ZNWHB5OHVicDgvSFFBeWp0cktLZ0cvTHBKUHB1?=
 =?utf-8?B?OVIrK21rMGtteUVyZjlqbkxtOXdHRm5OQkg2OCtxRFpjUTJnbkVjNEh5WWNC?=
 =?utf-8?B?L3FseDU2d3NldnZTbDY2ZjNDZDhtZjNvcDh4Q3JWTjFmNmRDS01XOE0vb1hU?=
 =?utf-8?B?SVVvNU1Mb2J2OGsyRlNhK2xsTmxSTW5tZVBsdGQ5Mk1Cc3Q5UXpLazRkZ0hG?=
 =?utf-8?B?TW4zUFBxVHI2YUFySkkwa3k4b1ZQMmliOHM4eDNYZlFXaC9BMVh3Q2lsamZr?=
 =?utf-8?B?TzlQS2hpOTFJVGQxaXdhS2s2dFd2OEZHL1RoT2tPWUtUbUlhTmE3dVRTZ2pJ?=
 =?utf-8?B?TUd4c1NaTnRKQnBCQmx6ZkVGd21qTmJ0OU52eVFVeGlWN3VmdUpTeWRESm9k?=
 =?utf-8?B?bVZNQlNIVkxpQzN4Y1F5aDk2NVhaMzI5cnJUNFFLY0c0R0planRyd1VsNUtX?=
 =?utf-8?B?V2hmSVd6OWFNRWhQTkhXb0dNeWpnbXJDdXhuTU0wc3RZSjlRWHFnSUxucDdK?=
 =?utf-8?B?OEhUMmpodlM0SXo4SEpOMCtkRVc1UUtmSmNQN3V1M3NncWV0aDhVRlRpNkF1?=
 =?utf-8?B?VG91Y09Ock9VMGpZenZrOTdFQ3JydFZWSDJJVVpLWEp6endKSTZ0N1lpOERS?=
 =?utf-8?B?MThLQVpKaWlLSC81Wktkdy9KMVdqYityVnRFWmxyRldCblpiQjNEc2R4aTZF?=
 =?utf-8?B?QVhWcDg2RmdUa1YwcDk4eWZablo1TVpJems3N2FGZ25hK2xJZ0dDRFBNdjBX?=
 =?utf-8?B?NGhGMDlFeGU1TFNzQU9BUy8zZ05MWXZQNFRrZ3hnVXphSG9PQUUwNHFJSnNX?=
 =?utf-8?B?cHhFZmoySVMxZzVJd2p5aWFhcThBMlRub1FtRW9aSEFWcVpXemwrZVBUck5Q?=
 =?utf-8?B?ZzI4TlZCVGZEWE1jcE42RmRycWZ0VU9Cdm9rYURrL2pRclRpRGt3VHo1Sy9z?=
 =?utf-8?B?QlNoeEllY2J5dkgwbmMxZ3c1b3ZvcWhUb1ljb2RwSVBFSlBBU0ZPdjhXalZ5?=
 =?utf-8?B?Y2FINmJXdTZUbHF4WnRoZUZ1WlhRemY1Z3JPdm41NUxBUEloTno5bGQvUTV5?=
 =?utf-8?B?ZmtmZW5zOTFOSmhoR0pya2VYR25sc0l5c2Y5NTNkU2FybGZ6bEdiMUpzc282?=
 =?utf-8?B?dmVMOHV5MmdWNDJ0bTcxbXZUT09uaHg4NnZkcDl5ak9VeFg4YitQb2JpVThM?=
 =?utf-8?B?UitvaXpXbU1PN2drcjB3aVc0QTZENmRrbksxUkJPSU1pZmRvbjFyaktwTFpY?=
 =?utf-8?B?NUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141fc58f-8097-43cf-2290-08da910c6594
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 20:06:05.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PtJnIotIPkypLDatvHvKWC4hpDoz2IyaZDj9D0ClnajJqxkrj5pq9VRSQXgAHxuTAiC31j3TcrDudR0i3onsYns6b9jTxuBSVf04qZD6jxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070075
X-Proofpoint-GUID: 7XZ-w4XVbsssuwQHQkHbOR1KuHii3PSP
X-Proofpoint-ORIG-GUID: 7XZ-w4XVbsssuwQHQkHbOR1KuHii3PSP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 2:48 AM, Dmitry Bogdanov wrote:
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index c14441c89bed..32fb38ce98f4 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -75,6 +75,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
>  	struct se_portal_group *tpg = lun->lun_tpg;
>  	struct se_device *dev = cmd->se_dev;
>  	struct se_session *sess = cmd->se_sess;
> +	struct se_lun *tmp_lun;
> +	size_t dev_ports = 0;
>  
>  	/* Set RMB (removable media) for tape devices */
>  	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
> @@ -115,6 +117,20 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
>  			buf[5] |= 0x1;
>  	}
>  
> +	spin_lock(&dev->se_port_lock);
> +	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
> +		dev_ports++;
> +		/* Exact number of ports does not matter for MULTIP bit */
> +		if (dev_ports > 1)
> +			break;

Can you just check se_deice->export_count instead of looping?

Also, setting the bit seems fine. I was just wondering what uses it?
