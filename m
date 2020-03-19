Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36974C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 17:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30D32071C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 17:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgCSRiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 13:38:50 -0400
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:36499 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgCSRiu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 13:38:50 -0400
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.147) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Thu, 19 Mar 2020 17:37:30 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 19 Mar 2020 17:31:20 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 19 Mar 2020 17:31:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmhgqDMEbfTidPD3pkfv7oI7VYNCa7kMlxja2w13t8M0qZQ/TsYAxw8ZG1eTsIPqWoyKjAt1KB5qWAAIObCN1llYauGE5zjqkf2Bk49Mgltcn2nBn2M3IhxLeV5g32f0bQr7s9XiMiGq7ikUeBkO1mvTveBhEAaata8elcWbx5Hi7833n4x/mkHBCScR7LhqVF/8K044tsBbR9HXkgzRPoRwtVWJRiWhBbk00N/4cgB3XY9j5CgB9IHKNXYFMlrBLkp7DqIBXX8KyV0CfTCjPVJXJn6mNOKxOlWzLZRVfaqohgRkEXE0SQUbAHI8FrpVY5sxVQ0tu/m96rEtfPCGRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14Ti18Z0ehIswL91BNXUiUya5nDxXK1R9jwm56DrM98=;
 b=Xvd0aBsr5U1kiRvLgRTvhS21WqmWMxtwIA/MFPEq0exQxiWfdp+tfz9eNb4oUyDfF3rQmc8+LrdiPa5dvPT40AQJPajDHa/FxgU9hFFDAdZxAoLYmpnWbfBE0x1TFG0B7amh84Zt5fqs9NjmoRw/wKIi9w7f3pfLvpeotg4vKBfF8g/p7uZF8TcYGPsMZDMD58k5f1afLXUh3yYChmTXgQkZd1yzCIzHwDxQehcR2opKisIMsHqh9jud8eqAQas2HalKyQ+rKYO8Yl/2tm0mkKOSgIIC+k2eJM/K2XvOyQT+dvWEgP6sZ8E1AWhTGBfnqFASrjgAsuvOgQQnIH2tuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
 by MN2PR18MB2911.namprd18.prod.outlook.com (2603:10b6:208:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Thu, 19 Mar
 2020 17:31:18 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316%5]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 17:31:17 +0000
Subject: Re: [PATCH RESEND v4] iscsi: Report connection state on sysfs
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
CC:     <bvanassche@acm.org>, <open-iscsi@googlegroups.com>,
        <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <kernel@collabora.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
References: <20200317233422.532961-1-krisman@collabora.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <2caa57c1-e1e2-3bb2-29f4-1c215016fca1@suse.com>
Date:   Thu, 19 Mar 2020 10:31:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200317233422.532961-1-krisman@collabora.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0230.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::26) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0230.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Thu, 19 Mar 2020 17:31:15 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a3345f0-02d1-449e-d3b1-08d7cc2b54de
X-MS-TrafficTypeDiagnostic: MN2PR18MB2911:
X-Microsoft-Antispam-PRVS: <MN2PR18MB291189A1030FDDCD826C4715DAF40@MN2PR18MB2911.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(199004)(956004)(81166006)(316002)(31686004)(6666004)(31696002)(52116002)(53546011)(6486002)(2616005)(8676002)(26005)(66556008)(86362001)(66946007)(66476007)(186003)(81156014)(6916009)(16576012)(478600001)(2906002)(8936002)(16526019)(36756003)(4326008)(54906003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2911;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgA0oZQK1qDmriPg99VDns/An//g9OObwXiiGpKkuah16Fvu5sdNu5UdFDSoKPe++ehHmf61AfdmGayiUuNPnp8oQo61NlGQ8xk8i9C+wxhep3hFdKGNPURfaUWimLBtgf/7plrTRxUJqeOHS49FbuZkQtgiRTvnxpsEK6oxPP2N3gn7PUxskJvE4YSKkHyI5Z22ofCPQNz+IOMLWKbqCR82Yy6IfYo7mlamPUzLts1c1Xlow4VscSvbmcNzSsp9ERjKcufEGz3zE4V8ZePYE7VE6qBsQqa1EvpXPLI4qkIZxCxwE0CRqpm0nq7qKa+DXJq29GiVcHNPgQxx99NA9MDpIfgI+tEBd+D9oJvOUkFmB2RGwlm+bukIeiKgoYob1Mj90mQRpv4NewDXe8WS1ReAjWJgDOmvXNaCSbOCtWPXgpKkp/X78Mkk/mv+DP8y
X-MS-Exchange-AntiSpam-MessageData: k7SRNVzEF0M/CJc2vH9C/vOaYVZKzzt3XKLT1Nh39WNE15NOBST5z3K4xQILPJgnRoVk1sbH38veAreEGhJ/9O1tlz6+oSvLCJSgo7TJO3Gv0+fcYoP2N4rUx4LPlBVf6GdXHoPQ97TLpvYCYLA+Rw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3345f0-02d1-449e-d3b1-08d7cc2b54de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 17:31:17.7822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzqP6b9/FaO5XXox6Ask1YbC/pPSn5bZjAjE3HtZtmtH05cslnv7uaAKJPK8zgiM2xXgK5JxGCRc1lhkyksHMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2911
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/20 4:34 PM, Gabriel Krisman Bertazi wrote:
> If an iSCSI connection happens to fail while the daemon isn't
> running (due to a crash or for another reason), the kernel failure
> report is not received.  When the daemon restarts, there is insufficient
> kernel state in sysfs for it to know that this happened.  open-iscsi
> tries to reopen every connection, but on different initiators, we'd like
> to know which connections have failed.
> 
> There is session->state, but that has a different lifetime than an iSCSI
> connection, so it doesn't directly relflect the connection state.
> 
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Suggested-by: Junho Ryu <jayr@google.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
> Changes since v3:
>   - Change state type to enum (Bart)
> 
> Changes since v2:
>   - Use designated initializers (Bart)
> 
> Changes since v1:
>   - Remove dependency of state values (Bart)
> 
>  drivers/scsi/libiscsi.c             |  7 ++++++-
>  drivers/scsi/scsi_transport_iscsi.c | 29 ++++++++++++++++++++++++++++-
>  include/scsi/scsi_transport_iscsi.h |  8 ++++++++
>  3 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 70b99c0e2e67..ca488c57ead4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3153,13 +3153,18 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
>  
>  	switch (flag) {
>  	case STOP_CONN_RECOVER:
> +		cls_conn->state = ISCSI_CONN_FAILED;
> +		break;
>  	case STOP_CONN_TERM:
> -		iscsi_start_session_recovery(session, conn, flag);
> +		cls_conn->state = ISCSI_CONN_DOWN;
>  		break;
>  	default:
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid stop flag %d\n", flag);
> +		return;
>  	}
> +
> +	iscsi_start_session_recovery(session, conn, flag);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_stop);
>  
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 17a45716a0fe..0ec1b31c75a9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2276,6 +2276,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  	INIT_LIST_HEAD(&conn->conn_list_err);
>  	conn->transport = transport;
>  	conn->cid = cid;
> +	conn->state = ISCSI_CONN_DOWN;
>  
>  	/* this is released in the dev's release function */
>  	if (!get_device(&session->dev))
> @@ -3709,8 +3710,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		break;
>  	case ISCSI_UEVENT_START_CONN:
>  		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> -		if (conn)
> +		if (conn) {
>  			ev->r.retcode = transport->start_conn(conn);
> +			if (!ev->r.retcode)
> +				conn->state = ISCSI_CONN_UP;
> +		}
>  		else
>  			err = -EINVAL;
>  		break;
> @@ -3907,6 +3911,26 @@ iscsi_conn_attr(tcp_xmit_wsf, ISCSI_PARAM_TCP_XMIT_WSF);
>  iscsi_conn_attr(tcp_recv_wsf, ISCSI_PARAM_TCP_RECV_WSF);
>  iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
>  
> +static const char *const connection_state_names[] = {
> +	[ISCSI_CONN_UP] = "up",
> +	[ISCSI_CONN_DOWN] = "down",
> +	[ISCSI_CONN_FAILED] = "failed"
> +};
> +
> +static ssize_t show_conn_state(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
> +	const char *state = "unknown";
> +
> +	if (conn->state >= 0 &&
> +	    conn->state < ARRAY_SIZE(connection_state_names))
> +		state = connection_state_names[conn->state];
> +
> +	return sprintf(buf, "%s\n", state);
> +}
> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
> +			NULL);
>  
>  #define iscsi_conn_ep_attr_show(param)					\
>  static ssize_t show_conn_ep_param_##param(struct device *dev,		\
> @@ -3976,6 +4000,7 @@ static struct attribute *iscsi_conn_attrs[] = {
>  	&dev_attr_conn_tcp_xmit_wsf.attr,
>  	&dev_attr_conn_tcp_recv_wsf.attr,
>  	&dev_attr_conn_local_ipaddr.attr,
> +	&dev_attr_conn_state.attr,
>  	NULL,
>  };
>  
> @@ -4047,6 +4072,8 @@ static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
>  		param = ISCSI_PARAM_TCP_RECV_WSF;
>  	else if (attr == &dev_attr_conn_local_ipaddr.attr)
>  		param = ISCSI_PARAM_LOCAL_IPADDR;
> +	else if (attr == &dev_attr_conn_state.attr)
> +		return S_IRUGO;
>  	else {
>  		WARN_ONCE(1, "Invalid conn attr");
>  		return 0;
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index fa8814245796..bdcb6d69d154 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -188,6 +188,13 @@ extern void iscsi_ping_comp_event(uint32_t host_no,
>  				  uint32_t status, uint32_t pid,
>  				  uint32_t data_size, uint8_t *data);
>  
> +/* iscsi class connection state */
> +enum iscsi_connection_state {
> +	ISCSI_CONN_UP = 0,
> +	ISCSI_CONN_DOWN,
> +	ISCSI_CONN_FAILED,
> +};
> +
>  struct iscsi_cls_conn {
>  	struct list_head conn_list;	/* item in connlist */
>  	struct list_head conn_list_err;	/* item in connlist_err */
> @@ -198,6 +205,7 @@ struct iscsi_cls_conn {
>  	struct iscsi_endpoint *ep;
>  
>  	struct device dev;		/* sysfs transport/container device */
> +	enum iscsi_connection_state state;
>  };
>  
>  #define iscsi_dev_to_conn(_dev) \
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
