Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65383C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 417FE207FC
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="KO8UWit8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgDTRkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 13:40:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.5]:46892 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbgDTRku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 13:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1587404448; i=@ts.fujitsu.com;
        bh=OuSpmpLx2M+buYaUsY9Us0sNH0iuHhN4pO/gMTPW3ao=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=KO8UWit8zRjzeaGUFO6HVrSR5tJWwa6NUI5cUopsDS1Lv+kPKGRLOeo9YDLPJRoLL
         3M48QaUNChMwg4tT5oi8DenSeLfesxz6yFyr0B1VqhLagYQd0bovlatLojd1XG2lM1
         FeColh2WdwnypbyxPJpcHfo6xgUMLHiFfOSRxMuiSB+OSBSEGN96FT4Gy6JqWH0Px7
         UDvIVFBDZ2ZuA6Nho1u86e6bsYxL1WjAKDPZznlqUogU4iro621h9JjDxKOZCgPkZc
         yU5JdbR3dEc+F2O0NSYDP4+PZ+Q/NgL9hnrJhD/krYW+j6KQQVpt+gpV1MYx3L1zmV
         /2pTr8yCCBcsw==
Received: from [100.112.195.143] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-west-1.aws.symcld.net id 5D/F7-46089-F9EDD9E5; Mon, 20 Apr 2020 17:40:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MxVXf+vbl
  xBj1z1C1WLHjPaNF9fQebxfLj/5gs1h/ZwGjRtvoMo0Xr0rdMDmweO2fdZfe4v/0Ik8fHp7dY
  PN7vu8rm8XmTXABrFGtmXlJ+RQJrxsH3r5gLzrBWLNq5hbWB8QBLFyMXh5DALEaJiQ0fmLoYO
  TmEBdwlpn7fwwaSEBHYwShxZOUXFpCEkECKxJPO12wgNpuAgcSKSffB4rwCjhIvHm9kB7FZBF
  QlVj6+BhYXFQiXeLHlDytEjaDEyZlPwOKcAhYS27b/BatnFjCTmLf5ITOELS5x68l8JghbXmL
  72znMExh5ZyFpn4WkZRaSlllIWhYwsqxitEgqykzPKMlNzMzRNTQw0DU0NNI1tDTSNTI11Uus
  0k3USy3VLU8tLtE11EssL9YrrsxNzknRy0st2cQIDPSUggP/dzCeWPte7xCjJAeTkihvX8rcO
  CG+pPyUyozE4oz4otKc1OJDjDIcHEoSvBl3gXKCRanpqRVpmTnAqINJS3DwKInwvgRJ8xYXJO
  YWZ6ZDpE4xKkqJ82qDJARAEhmleXBtsEi/xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmYtwp
  kCk9mXgnc9FdAi5mAFuebzgZZXJKIkJJqYFp1YG+hgUCy4Lymk/fMrFdqze6drSyqxrOo7OLX
  6yuTpTV+v1bg/ublLy70nIPn1V09I+VHWh0neOeddbib72mXsemrfsyUB/NMWvIX2jfqJOgtf
  q9XdavqUK293FHLfhXn8tXVvA/MTD48uGp5ysIpImXTtNw7U7+mdMxVzzkYU+HanxDu49ch/H
  qSz9c1bQtcWs5cDviTHPxGbVZU0forNRNV7Bt+pm4MX/zx1QyJvG8qPWum/vrbu4/1rl3GAY0
  cyxKlJP89ro6iogbrFY0v1P3KXvSodOe/y6ZT9H0UwlmjOH7+PPLS4W4Je/faz9Jv+eJd1V+v
  udvKYc9f9T5kkY5yzx2Zhdo8lUHflFiKMxINtZiLihMBwQk99m8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-13.tower-265.messagelabs.com!1587404447!466355!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 4084 invoked from network); 20 Apr 2020 17:40:47 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-13.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 20 Apr 2020 17:40:47 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 03KHe4cp024644;
        Mon, 20 Apr 2020 18:40:25 +0100
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
Date:   Mon, 20 Apr 2020 19:39:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200414051514.7296-3-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 04/14/20 07:15, Mike Christie wrote:
> +static ssize_t session_acl_show(struct se_session *se_sess, char *page)
> +{
> +	struct se_node_acl *acl;
> +	ssize_t len;
> +
> +	acl = se_sess->se_node_acl;
> +	if (!acl)
> +		return -ENOTCONN;
> +
> +	if (acl->dynamic_node_acl) {
> +		page[0] = '\0';
> +		len = 0;
> +	} else {
> +		len = snprintf(page, PAGE_SIZE, "%s\n", acl->initiatorname);
> +	}
> +
> +	return len;
> +}

Would it be a good idea to provide more info about initiators using
dynamic acl?

For example the file could be named "initiatorname" instead of "acl" and
always provide the initiatorname, while a boolean file "acl" could 
return "Y" or "1" for explicit acls, but "N" or "0" for dynamic acls.

