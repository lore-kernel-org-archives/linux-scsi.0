Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E36CC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 23:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A496620693
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 23:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbgEMX7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 19:59:48 -0400
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:38765 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732456AbgEMX7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 19:59:47 -0400
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.146) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Wed, 13 May 2020 23:57:26 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 13 May 2020 23:59:24 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 13 May 2020 23:59:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y32xDYyjJGsNVQb9yoIdExS1DUTU/v9B9ID/AEX27mvXrNb+5+zO1jf6r+HEF1FlokES8utELWCZMxTQlqn8iLu7FD8iE7KQbKimSSrovc78g1gy37U3YhkYepAn99GHnIY8eqUYbEhZBoQmQnoQvRyg2c9MEkbfLxltiCEf0JGOn8fNFx19y6eL8mXdiCf+UrkTQhgXbS5RoDq61kU8GG9P0rG9komDWuMEXDf3xtKhSvyShJFhiIz7OYPR8BtqB9BJalV7ooTnMMquDR4r1OetTastow96L+2kyGfECl7mFEIJM6/7/jIHhKnwmbKqexoquys1YwEwOLvqHY3yWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/WaQycaPJ1xYGpiACUIH8jQ8fqZ0xlXfxp29SCNp9I=;
 b=XWY0WkK2U4xnpUnmQsPeLaZkftofmhqfTml472jtpW4XvNbSLEZ9VvWaOOspTXz7dELrePCOirPRmDzLaU3mqqw22YKKfXZkLCUbtqY6Y0wCVU/noLeE2mW+hAiFZHjeSAYMX1NgHeQAGCsKw1Lp39Re/v3svl6mH5AHkAkeR+g7Qw3n07yEOHzUxnZJo+yARGK+wzxucJZzXdprruwXB67FsRwoXUpZI6COgmHtYfwoAUpmMXUvFQXujmaXWnmPZhUuvH08QxIxo/ZJZD/VUYV7oTJQpWXa35bSliSV8kMkUBCYe1gxhsG0hSD/6nzGg5Nves+6JEZF6p3Nia/gbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from BL0PR18MB2290.namprd18.prod.outlook.com (2603:10b6:207:48::11)
 by BL0PR18MB2321.namprd18.prod.outlook.com (2603:10b6:207:48::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Wed, 13 May
 2020 23:59:23 +0000
Received: from BL0PR18MB2290.namprd18.prod.outlook.com
 ([fe80::9ddc:db5b:9a5a:6b3d]) by BL0PR18MB2290.namprd18.prod.outlook.com
 ([fe80::9ddc:db5b:9a5a:6b3d%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 23:59:23 +0000
Subject: Re: [PATCH 04/15] tcm loop: use target_parse_emulated_name
To:     Mike Christie <mchristi@redhat.com>, <bvanassche@acm.org>,
        <bstroesser@ts.fujitsu.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-5-mchristi@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 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
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <2cb2e526-0ba6-f6ce-ede9-949f2ef6a49b@suse.com>
Date:   Wed, 13 May 2020 16:59:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200510215744.21999-5-mchristi@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:805:f2::46) To BL0PR18MB2290.namprd18.prod.outlook.com
 (2603:10b6:207:48::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by SN6PR04CA0105.namprd04.prod.outlook.com (2603:10b6:805:f2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 23:59:22 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cef06d0-f9ee-480a-118c-08d7f799a8e7
X-MS-TrafficTypeDiagnostic: BL0PR18MB2321:
X-Microsoft-Antispam-PRVS: <BL0PR18MB2321E5BE17CBACCF805CCC9DDABF0@BL0PR18MB2321.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:234;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5r6Nl+ZDkc1jCRSyLr1H0swqN2sdRXnBsAmtw/YPyqALBCIc11goUacTGLm/JfLEkHykVogSi1rp01nwLISS+V8A81uaTCXO+Y4ROZx1tjl1D45YfpigRkxiMwxHefy/K52lQCqc6pxG5jORWLbFkjwVpueGAcLCpyDGbOsYhNEJqeNwVZP2o5nJGjgP6U7F1f//YlEX8E+fP+6Nw93R6imQCARNrkqR/BXKsgClFN7fcuhLwBIXXrHHLP06YrVNbLKjH349EhkH4zCUOviG429IxndiBX3eFziQ0l3alBWfgDcS/bDt/+3hX491CbgXs4vsdgIDfw5JcS35QIvmO8zVKvjWlRiEuxFhRwrr5WR2/Hf17l6/WsbN15lD3VoiH5Yf38pshJ3n5A3Pk/k64PaQYz1BbW6QGeViVog4wbppUhWPR5aWd3lzprjCJx1hZa/ZZoESjUyF5m5KSKFUyJuIaTpDiovc/tPGFWfZLsF4vuJ0E3fsAmcZVRf+dFQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR18MB2290.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(316002)(26005)(31686004)(6486002)(478600001)(5660300002)(53546011)(2616005)(2906002)(16526019)(186003)(31696002)(956004)(86362001)(8936002)(66476007)(66946007)(66556008)(52116002)(8676002)(16576012)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wHwbh63sm8PMrAqY6030obdjmFLwafspEx+Q4OvBffYXtZiIelJuNPCmqRK38d+ud+2+XlavnBttdN9QX61dpRpqX2W1MougsKlbNdv2rEX4OXuVCn+NJn3Uh7atVV1yYCEuCVM1sgdFOloGNTiquGMMfiycScJMtN6TKrCqJZ6QMvm+lIGzwYxaJtl9x6v6Wn01SqrUjeL9bAtsP/QCoZ/7QtRw2R4yH+3HJI5hr0A7NtDyoyRCqM1bVPBziHkn1wv12b3s+NQmJVOPvpAigs59mVT7K7kM45xjkLyjaHwNDNHsgxa+WUUbAHtPZtV5GyUn1herT4ogrZBfdipTH8kAAc4WI50vte/wYZlYCSf+8Xfh4rc+gzyLPlxCeRsw6yG1m2Av2jO1LGDFgcfJlbeIYiq75vaDTijzEhm17in759OxPWTKWoDglSDbgdcPg7FKjYv98Omp2G+BDCop++aCn+uWBWfzCMnjxuoxwhI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cef06d0-f9ee-480a-118c-08d7f799a8e7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 23:59:23.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksWRgaggB2wlgOkIRzWiYYH99gpevOG71v9G7kx3R/0kvwLBo480/u0C3SeJrWz7YxdZEqYKUzTzKThogmntXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2321
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 2:57 PM, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are properly
> formatted.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/loopback/tcm_loop.c | 65 ++++++--------------------------------
>  1 file changed, 10 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 74aded7..64e5f1f 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -725,7 +725,8 @@ static int tcm_loop_alloc_sess_cb(struct se_portal_group *se_tpg,
>  
>  static int tcm_loop_make_nexus(
>  	struct tcm_loop_tpg *tl_tpg,
> -	const char *name)
> +	const char *tpt_id_name,
> +	const char *acl_name)
>  {
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
>  	struct tcm_loop_nexus *tl_nexus;
> @@ -742,7 +743,7 @@ static int tcm_loop_make_nexus(
>  
>  	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
>  					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
> -					name, name, tl_nexus,
> +					tpt_id_name, acl_name, tl_nexus,
>  					tcm_loop_alloc_sess_cb);
>  	if (IS_ERR(tl_nexus->se_sess)) {
>  		ret = PTR_ERR(tl_nexus->se_sess);
> @@ -751,7 +752,7 @@ static int tcm_loop_make_nexus(
>  	}
>  
>  	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
> -		 tcm_loop_dump_proto_id(tl_hba), name);
> +		 tcm_loop_dump_proto_id(tl_hba), acl_name);
>  	return 0;
>  }
>  
> @@ -814,7 +815,7 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
>  	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
>  			struct tcm_loop_tpg, tl_se_tpg);
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
> -	unsigned char i_port[TL_WWN_ADDR_LEN], *ptr, *port_ptr;
> +	unsigned char i_port[TL_WWN_ADDR_LEN], *tpt_id_name;
>  	int ret;
>  	/*
>  	 * Shutdown the active I_T nexus if 'NULL' is passed..
> @@ -823,59 +824,13 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
>  		ret = tcm_loop_drop_nexus(tl_tpg);
>  		return (!ret) ? count : ret;
>  	}
> -	/*
> -	 * Otherwise make sure the passed virtual Initiator port WWN matches
> -	 * the fabric protocol_id set in tcm_loop_make_scsi_hba(), and call
> -	 * tcm_loop_make_nexus()
> -	 */
> -	if (strlen(page) >= TL_WWN_ADDR_LEN) {
> -		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
> -		       page, TL_WWN_ADDR_LEN);
> -		return -EINVAL;
> -	}
> -	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
>  
> -	ptr = strstr(i_port, "naa.");
> -	if (ptr) {
> -		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
> -			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
> -			       i_port, tcm_loop_dump_proto_id(tl_hba));
> -			return -EINVAL;
> -		}
> -		port_ptr = &i_port[0];
> -		goto check_newline;
> -	}
> -	ptr = strstr(i_port, "fc.");
> -	if (ptr) {
> -		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
> -			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
> -			       i_port, tcm_loop_dump_proto_id(tl_hba));
> -			return -EINVAL;
> -		}
> -		port_ptr = &i_port[3]; /* Skip over "fc." */
> -		goto check_newline;
> -	}
> -	ptr = strstr(i_port, "iqn.");
> -	if (ptr) {
> -		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
> -			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
> -			       i_port, tcm_loop_dump_proto_id(tl_hba));
> -			return -EINVAL;
> -		}
> -		port_ptr = &i_port[0];
> -		goto check_newline;
> -	}
> -	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
> -	       i_port);
> -	return -EINVAL;
> -	/*
> -	 * Clear any trailing newline for the NAA WWN
> -	 */
> -check_newline:
> -	if (i_port[strlen(i_port)-1] == '\n')
> -		i_port[strlen(i_port)-1] = '\0';
> +	ret = target_parse_emulated_name(tl_hba->tl_proto_id, page, i_port,
> +					 TL_WWN_ADDR_LEN, &tpt_id_name);
> +	if (ret)
> +		return ret;
>  
> -	ret = tcm_loop_make_nexus(tl_tpg, port_ptr);
> +	ret = tcm_loop_make_nexus(tl_tpg, tpt_id_name, i_port);
>  	if (ret < 0)
>  		return ret;
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
