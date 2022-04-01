Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3838BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 09:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiDAJSw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 05:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiDAJSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 05:18:52 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52CC1DBA9D
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 02:17:02 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KVDzD5pHxzgYDy;
        Fri,  1 Apr 2022 17:15:20 +0800 (CST)
Received: from dggpeml100019.china.huawei.com (7.185.36.175) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:17:01 +0800
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml100019.china.huawei.com (7.185.36.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 1 Apr 2022 17:17:01 +0800
Received: from dggpeml500019.china.huawei.com ([7.185.36.137]) by
 dggpeml500019.china.huawei.com ([7.185.36.137]) with mapi id 15.01.2308.021;
 Fri, 1 Apr 2022 17:17:01 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "njavali@marvell.com" <njavali@marvell.com>,
        "mrangankar@marvell.com" <mrangankar@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH V3 01/15] scsi: iscsi: Move iscsi_ep_disconnect
Thread-Topic: [PATCH V3 01/15] scsi: iscsi: Move iscsi_ep_disconnect
Thread-Index: AQHYQ5efa/dY63sDNkaO2TD4jZ/lwqzayryQ
Date:   Fri, 1 Apr 2022 09:17:01 +0000
Message-ID: <ab4ab242c12a447da17f5210a8a569b8@huawei.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
 <20220329180326.5586-2-michael.christie@oracle.com>
In-Reply-To: <20220329180326.5586-2-michael.christie@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.189]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 11:03, Mike Christie wrote:
> 
> This patch moves iscsi_ep_disconnect so it can be called earlier in the next patch.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 27951ea05dd4..4e10457e3ab9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2217,6 +2217,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn,
> int flag)
>  	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");  }
> 
> +static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool
> +is_active) {
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +	struct iscsi_endpoint *ep;
> +
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> +	conn->state = ISCSI_CONN_FAILED;
> +
> +	if (!conn->ep || !session->transport->ep_disconnect)
> +		return;
> +
> +	ep = conn->ep;
> +	conn->ep = NULL;
> +
> +	session->transport->unbind_conn(conn, is_active);
> +	session->transport->ep_disconnect(ep);
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n"); }
> +
>  static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  			      struct iscsi_uevent *ev)
>  {
> @@ -2257,25 +2276,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport
> *transport,
>  	return 0;
>  }
> 
> -static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active) -{
> -	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> -	struct iscsi_endpoint *ep;
> -
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> -	conn->state = ISCSI_CONN_FAILED;
> -
> -	if (!conn->ep || !session->transport->ep_disconnect)
> -		return;
> -
> -	ep = conn->ep;
> -	conn->ep = NULL;
> -
> -	session->transport->unbind_conn(conn, is_active);
> -	session->transport->ep_disconnect(ep);
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> -}
> -
>  static void iscsi_cleanup_conn_work_fn(struct work_struct *work)  {
>  	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
> --
> 2.25.1

Reviewed-by: Wu Bo <wubo40@huawei.com>
