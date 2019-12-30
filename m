Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9191C2D0C2
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 16:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 947A620409
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 16:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfL3Q44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 11:56:56 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43901 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfL3Q4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 11:56:55 -0500
Received: by mail-pl1-f196.google.com with SMTP id p27so14841572pli.10;
        Mon, 30 Dec 2019 08:56:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XCYgvoQKBvOER9YgV618365ENGxaijfZPj72YD+0eiU=;
        b=RQFD4i7tQw6fs5Bemb26QaD05xei4TtM+q2HiCmgSeRiQnA0mWy5IFdQi1qJJudEtV
         5KL7Z6NPS+4bOPAAIyu06NlXe/JVvDdqpOLqquseVcEzPsqxlFanaxGeamlKR4QD133v
         78ee50ryKKq2aYwKkwAE04MPV/W7SvjP8MY+qkwZK96diEVPMOh1+cB917uZ8umJQWh7
         O+tZKflLtlsd8NMTUjx5072nLarK7wzqPByAPQG+ltrot81THGyMRh9hy9rKX6Oa0VQ7
         yBZ4t2zpxm4aix6xVD4bEob2gqIuFL+aK9EGGwsYEsLKqEyuXxRdtTLT7USBWwxGWRRQ
         AbKw==
X-Gm-Message-State: APjAAAU2DqPTxiP/kpGxl7wRo0esK1ux1JFvYXt9ehr7Gj958DuTL8tb
        7WFkEHJAbKrWnsPkLxl1agD9oVec
X-Google-Smtp-Source: APXvYqwWM5eacO8yLTj54QkR4a0waPpIJXnhrli+Kvv18VWg4GwoKhwRKwFGisfLiXPGf0MXNZWvPQ==
X-Received: by 2002:a17:902:8342:: with SMTP id z2mr67001993pln.181.1577725014462;
        Mon, 30 Dec 2019 08:56:54 -0800 (PST)
Received: from ?IPv6:2601:647:4000:10b0:5d64:b7bb:4214:150f? ([2601:647:4000:10b0:5d64:b7bb:4214:150f])
        by smtp.gmail.com with ESMTPSA id 68sm48115636pge.14.2019.12.30.08.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 08:56:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: Trace seen on target during iSER login
To:     Rahul Kundu <rahul.kundu@chelsio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>
References: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
Date:   Mon, 30 Dec 2019 08:56:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-29 23:21, Rahul Kundu wrote:
> Below is the patch diff which removes redundant function calls added by the above commit, but I am not sure whether this is the ideal fix:
> =================================================================================================================
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 7251a87bb576..503a76e9cc62 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4234,8 +4234,6 @@ int iscsit_close_connection(
>          * must wait until they have completed.
>          */
>         iscsit_check_conn_usage_count(conn);
> -       target_sess_cmd_list_set_waiting(sess->se_sess);
> -       target_wait_for_sess_cmds(sess->se_sess);
> 
>         ahash_request_free(conn->conn_tx_hash);
>         if (conn->conn_rx_hash) {

I don't like the above change because it would reintroduce the issue fixed by
commit e9d3009cb936. How about the patch below?

Thanks,

Bart.


From f25182525499b52db6be00b34dbfd3662d29e403 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 30 Dec 2019 07:48:20 -0800
Subject: [PATCH] RDMA/isert: Fix a recently introduced regression related to
 logout

iscsit_close_connection() calls isert_wait_conn(). Due to commit
e9d3009cb936 both functions call target_wait_for_sess_cmds() although
that last function should be called only once. Fix this by removing
the target_wait_for_sess_cmds() call from isert_wait_conn() and by
only calling isert_wait_conn() after target_wait_for_sess_cmds().

Reported-by: Rahul Kundu <rahul.kundu@chelsio.com>
Fixes: e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish before freeing a session").
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 drivers/target/iscsi/iscsi_target.c     |  6 +++---
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a1a035270cab..b273e421e910 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2575,17 +2575,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }

-static void
-isert_wait4cmds(struct iscsi_conn *conn)
-{
-	isert_info("iscsi_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2633,7 +2622,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)

 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);

 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7251a87bb576..b94ed4e30770 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4149,9 +4149,6 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);

-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4237,6 +4234,9 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);

+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;
