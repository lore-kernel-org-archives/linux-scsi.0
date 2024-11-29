Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE24145A17;
	Fri, 29 Nov 2024 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894844; cv=none; b=csvajgWLvXV3OOpyZ1nF6gTN6qXyAfQFp2RWZEfL/sgSxTc+DbOz5a1HQ/md8BJxItf2ybJDzmXMDj5d597knt2NYvLNSrOTmvMtw3iDCYbnrccvUyFCIFr0bkoBM60JvZLTi6mkPkX8J4IC+NuDRTGMjD9KwqsQ4wRzXPi91KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894844; c=relaxed/simple;
	bh=rUhcY/mgam5bsBx2Lb+NmOdM38LczjVxnBJBKwnrTHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fyp6B+Ogu6tfjayedu+7XM8ohNowMCmUDHt50zx8s54UEClqiXNk406fYvsmg8qfMF45tRE1odQS9Zh7XSP4w94mDQ5UZ7SxLgRNEUNWb0xnrAMOYHMO48/Lkfp3YXeEUn0HNGNj/OEnWHf2Z6j6di65LacCwcMkZ/fP3pFp2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=XoYueFVA; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=qPyAO2gJ; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="XoYueFVA";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="qPyAO2gJ"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 58D3CE0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894345; bh=DC5iO7CCNJ1jIi2Vg30P7p9tSrEqNGM5GzEaCDAXWho=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=XoYueFVAmf/HVe0aPFrWDSME3eUJRR9f1ZtdkFLs9Yc277aYWNIuOxFupI/HBtQbo
	 +iESLh/cYvB0U2MLyx6yPITg3NhHrsXiuurmf1yqEaxhSOUM0mzF+HOAL1bOMYqBeW
	 JuV3A/o+1yAuc0ciqvL7CyUyb5S22A8eZp/Gw2HgJhNC5UyTigRZ2z1NIEsg4cFBF0
	 kmasodfN2IiDY5Zm5JulckBYB61BHwJ0QveMiXI6ZbXq72TmqiQYQzquzXn0hGWZCC
	 V6TGDBAgcCmfJcCStHKVoseenxMMhZogL8wO60d/y6SPT+ZXsx70KLxZvzetgh9fYw
	 UdzftUwxT8Dwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894345; bh=DC5iO7CCNJ1jIi2Vg30P7p9tSrEqNGM5GzEaCDAXWho=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=qPyAO2gJmOxITjVHtEboqHqg2i6ErtbSr5kvgZtqMCOR0j0wfGrl7U2pWZOOuqf81
	 IDfU9UrCSdH08LwizZmN5mGFnIPqnKfn7PrDERQi1E57IDMZNHFiQMuMZ5gnytoqqy
	 0VD86Cwt4wl+Z1DOZKwYlX3EIP7RbS6Chox/mYG/FEF1kd+HHGS+1qfocw1LWd1B9L
	 4apX1oei+Bmc8zt/FQECUYNe3FTeVGEO9COKLxjEeTisOT+IkWuujD8Xy63hr63IJG
	 U4AT56Ocprco79lncOTbvnNsy2HHXc7lHaTQL6Kze71e47wYQV5hMupOYvPGswokev
	 CrkkY4V1U9PzQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 02/10] target: Use new log wrappers
Date: Fri, 29 Nov 2024 18:30:48 +0300
Message-ID: <20241129153056.6985-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-07.corp.yadro.com (172.17.11.57) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This patch was made with this zsh script:

........................................................................
dir="/path/to/kernel/src/drivers/target"
printk_level=("DEBUG" "INFO" "NOTICE" "WARNING" "ERR")
level=("debug" "info" "notice" "warn" "err")

for file in $dir/**/*.{c,h}; do
    for (( i=1; i<=${#level[@]}; i++ )); do
        sed -i "s/pr_${level[$i]}/target_${level[$i]}/g" $file
        sed -i "s/printk(KERN_${printk_level[$i]} /target_${level[$i]}(/g" $file
        sed -i "s/printk(\"/target_err(\"/g" $file
    done
done
........................................................................

And then all format strings arguments were aligned by parenthesis by
git-clang-format util.

It may not be checked manually.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c       | 191 ++---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c      |  17 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c     |  45 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   | 131 ++--
 drivers/target/iscsi/iscsi_target.c           | 659 ++++++++--------
 drivers/target/iscsi/iscsi_target_auth.c      | 125 ++--
 drivers/target/iscsi/iscsi_target_configfs.c  | 107 ++-
 .../target/iscsi/iscsi_target_datain_values.c |  21 +-
 drivers/target/iscsi/iscsi_target_device.c    |   2 +-
 drivers/target/iscsi/iscsi_target_erl0.c      | 185 ++---
 drivers/target/iscsi/iscsi_target_erl1.c      | 196 ++---
 drivers/target/iscsi/iscsi_target_erl2.c      |  72 +-
 drivers/target/iscsi/iscsi_target_login.c     | 164 ++--
 drivers/target/iscsi/iscsi_target_nego.c      | 225 +++---
 .../target/iscsi/iscsi_target_nodeattrib.c    | 112 +--
 .../target/iscsi/iscsi_target_parameters.c    | 377 +++++-----
 .../target/iscsi/iscsi_target_seq_pdu_list.c  |  98 ++-
 drivers/target/iscsi/iscsi_target_tmr.c       | 150 ++--
 drivers/target/iscsi/iscsi_target_tpg.c       | 194 ++---
 drivers/target/iscsi/iscsi_target_transport.c |   4 +-
 drivers/target/iscsi/iscsi_target_util.c      | 147 ++--
 drivers/target/loopback/tcm_loop.c            | 112 ++-
 drivers/target/sbp/sbp_target.c               | 148 ++--
 drivers/target/target_core_alua.c             | 213 +++---
 drivers/target/target_core_configfs.c         | 612 ++++++++-------
 drivers/target/target_core_device.c           | 119 ++-
 drivers/target/target_core_fabric_configfs.c  |  68 +-
 drivers/target/target_core_fabric_lib.c       |  25 +-
 drivers/target/target_core_file.c             | 140 ++--
 drivers/target/target_core_hba.c              |  18 +-
 drivers/target/target_core_iblock.c           |  98 ++-
 drivers/target/target_core_pr.c               | 702 +++++++++---------
 drivers/target/target_core_pscsi.c            | 185 ++---
 drivers/target/target_core_rd.c               |  92 ++-
 drivers/target/target_core_sbc.c              | 162 ++--
 drivers/target/target_core_spc.c              |  31 +-
 drivers/target/target_core_tmr.c              |  55 +-
 drivers/target/target_core_tpg.c              |  90 ++-
 drivers/target/target_core_transport.c        | 233 +++---
 drivers/target/target_core_ua.c               |  30 +-
 drivers/target/target_core_user.c             | 243 +++---
 drivers/target/target_core_xcopy.c            | 242 +++---
 drivers/target/tcm_fc/tfc_cmd.c               |  48 +-
 drivers/target/tcm_fc/tfc_conf.c              |  14 +-
 drivers/target/tcm_fc/tfc_io.c                |  23 +-
 drivers/target/tcm_fc/tfc_sess.c              |   4 +-
 drivers/target/tcm_remote/tcm_remote.c        |  39 +-
 47 files changed, 3434 insertions(+), 3534 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index d9204c590d9a..2575549cb579 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -40,7 +40,7 @@ cxgbit_wake_up(struct cxgbit_wr_wait *wr_waitp, const char *func, u8 ret)
 		wr_waitp->ret = -EIO;
 
 	if (wr_waitp->ret)
-		pr_err("%s: err:%u", func, ret);
+		target_err("%s: err:%u", func, ret);
 
 	complete(&wr_waitp->completion);
 }
@@ -59,14 +59,14 @@ cxgbit_wait_for_reply(struct cxgbit_device *cdev,
 
 	ret = wait_for_completion_timeout(&wr_waitp->completion, timeout * HZ);
 	if (!ret) {
-		pr_info("%s - Device %s not responding tid %u\n",
-			func, pci_name(cdev->lldi.pdev), tid);
+		target_info("%s - Device %s not responding tid %u\n", func,
+			    pci_name(cdev->lldi.pdev), tid);
 		wr_waitp->ret = -ETIMEDOUT;
 	}
 out:
 	if (wr_waitp->ret)
-		pr_info("%s: FW reply %d tid %u\n",
-			pci_name(cdev->lldi.pdev), wr_waitp->ret, tid);
+		target_info("%s: FW reply %d tid %u\n", pci_name(cdev->lldi.pdev), wr_waitp->ret,
+			    tid);
 	return wr_waitp->ret;
 }
 
@@ -149,8 +149,8 @@ cxgbit_create_server6(struct cxgbit_device *cdev, unsigned int stid,
 	int addr_type;
 	int ret;
 
-	pr_debug("%s: dev = %s; stid = %u; sin6_port = %u\n",
-		 __func__, cdev->lldi.ports[0]->name, stid, sin6->sin6_port);
+	target_debug("%s: dev = %s; stid = %u; sin6_port = %u\n", __func__,
+		     cdev->lldi.ports[0]->name, stid, sin6->sin6_port);
 
 	addr_type = ipv6_addr_type((const struct in6_addr *)
 				   &sin6->sin6_addr);
@@ -158,8 +158,8 @@ cxgbit_create_server6(struct cxgbit_device *cdev, unsigned int stid,
 		ret = cxgb4_clip_get(cdev->lldi.ports[0],
 				     (const u32 *)&sin6->sin6_addr.s6_addr, 1);
 		if (ret) {
-			pr_err("Unable to find clip table entry. laddr %pI6. Error:%d.\n",
-			       sin6->sin6_addr.s6_addr, ret);
+			target_err("Unable to find clip table entry. laddr %pI6. Error:%d.\n",
+				   sin6->sin6_addr.s6_addr, ret);
 			return -ENOMEM;
 		}
 	}
@@ -184,9 +184,8 @@ cxgbit_create_server6(struct cxgbit_device *cdev, unsigned int stid,
 			cxgb4_clip_release(cdev->lldi.ports[0],
 				   (const u32 *)&sin6->sin6_addr.s6_addr, 1);
 
-		pr_err("create server6 err %d stid %d laddr %pI6 lport %d\n",
-		       ret, stid, sin6->sin6_addr.s6_addr,
-		       ntohs(sin6->sin6_port));
+		target_err("create server6 err %d stid %d laddr %pI6 lport %d\n", ret, stid,
+			   sin6->sin6_addr.s6_addr, ntohs(sin6->sin6_port));
 	}
 
 	return ret;
@@ -200,8 +199,8 @@ cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
 				   &cnp->com.local_addr;
 	int ret;
 
-	pr_debug("%s: dev = %s; stid = %u; sin_port = %u\n",
-		 __func__, cdev->lldi.ports[0]->name, stid, sin->sin_port);
+	target_debug("%s: dev = %s; stid = %u; sin_port = %u\n", __func__,
+		     cdev->lldi.ports[0]->name, stid, sin->sin_port);
 
 	cxgbit_get_cnp(cnp);
 	cxgbit_init_wr_wait(&cnp->com.wr_wait);
@@ -220,8 +219,8 @@ cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
 		cxgbit_put_cnp(cnp);
 
 	if (ret)
-		pr_err("create server failed err %d stid %d laddr %pI4 lport %d\n",
-		       ret, stid, &sin->sin_addr, ntohs(sin->sin_port));
+		target_err("create server failed err %d stid %d laddr %pI4 lport %d\n", ret, stid,
+			   &sin->sin_addr, ntohs(sin->sin_port));
 	return ret;
 }
 
@@ -248,8 +247,7 @@ struct cxgbit_device *cxgbit_find_device(struct net_device *ndev, u8 *port_id)
 static struct net_device *cxgbit_get_real_dev(struct net_device *ndev)
 {
 	if (ndev->priv_flags & IFF_BONDING) {
-		pr_err("Bond devices are not supported. Interface:%s\n",
-		       ndev->name);
+		target_err("Bond devices are not supported. Interface:%s\n", ndev->name);
 		return NULL;
 	}
 
@@ -640,7 +638,7 @@ static void cxgbit_arp_failure_discard(void *handle, struct sk_buff *skb)
 {
 	struct cxgbit_sock *csk = handle;
 
-	pr_debug("%s cxgbit_device %p\n", __func__, handle);
+	target_debug("%s cxgbit_device %p\n", __func__, handle);
 	kfree_skb(skb);
 	cxgbit_put_csk(csk);
 }
@@ -650,7 +648,7 @@ static void cxgbit_abort_arp_failure(void *handle, struct sk_buff *skb)
 	struct cxgbit_device *cdev = handle;
 	struct cpl_abort_req *req = cplhdr(skb);
 
-	pr_debug("%s cdev %p\n", __func__, cdev);
+	target_debug("%s cdev %p\n", __func__, cdev);
 	req->cmd = CPL_ABORT_NO_RST;
 	cxgbit_ofld_send(cdev, skb);
 }
@@ -660,8 +658,7 @@ static int cxgbit_send_abort_req(struct cxgbit_sock *csk)
 	struct sk_buff *skb;
 	u32 len = roundup(sizeof(struct cpl_abort_req), 16);
 
-	pr_debug("%s: csk %p tid %u; state %d\n",
-		 __func__, csk, csk->tid, csk->com.state);
+	target_debug("%s: csk %p tid %u; state %d\n", __func__, csk, csk->tid, csk->com.state);
 
 	__skb_queue_purge(&csk->txq);
 
@@ -720,8 +717,7 @@ static void __cxgbit_free_conn(struct cxgbit_sock *csk)
 	struct iscsit_conn *conn = csk->conn;
 	bool release = false;
 
-	pr_debug("%s: state %d\n",
-		 __func__, csk->com.state);
+	target_debug("%s: state %d\n", __func__, csk->com.state);
 
 	spin_lock_bh(&csk->lock);
 	switch (csk->com.state) {
@@ -742,8 +738,7 @@ static void __cxgbit_free_conn(struct cxgbit_sock *csk)
 		release = true;
 		break;
 	default:
-		pr_err("%s: csk %p; state %d\n",
-		       __func__, csk, csk->com.state);
+		target_err("%s: csk %p; state %d\n", __func__, csk, csk->com.state);
 	}
 	spin_unlock_bh(&csk->lock);
 
@@ -768,10 +763,10 @@ static void cxgbit_set_emss(struct cxgbit_sock *csk, u16 opt)
 	if (csk->emss < 128)
 		csk->emss = 128;
 	if (csk->emss & 7)
-		pr_info("Warning: misaligned mtu idx %u mss %u emss=%u\n",
-			TCPOPT_MSS_G(opt), csk->mss, csk->emss);
-	pr_debug("%s mss_idx %u mss %u emss=%u\n", __func__, TCPOPT_MSS_G(opt),
-		 csk->mss, csk->emss);
+		target_info("Warning: misaligned mtu idx %u mss %u emss=%u\n", TCPOPT_MSS_G(opt),
+			    csk->mss, csk->emss);
+	target_debug("%s mss_idx %u mss %u emss=%u\n", __func__, TCPOPT_MSS_G(opt), csk->mss,
+		     csk->emss);
 }
 
 static void cxgbit_free_skb(struct cxgbit_sock *csk)
@@ -797,7 +792,7 @@ void _cxgbit_free_csk(struct kref *kref)
 
 	csk = container_of(kref, struct cxgbit_sock, kref);
 
-	pr_debug("%s csk %p state %d\n", __func__, csk, csk->com.state);
+	target_debug("%s csk %p state %d\n", __func__, csk, csk->com.state);
 
 	if (csk->com.local_addr.ss_family == AF_INET6) {
 		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
@@ -844,8 +839,7 @@ static void cxgbit_set_tcp_window(struct cxgbit_sock *csk, struct port_info *pi)
 		csk->snd_win *= scale;
 	csk->snd_win = min(csk->snd_win, 512U * 1024);
 
-	pr_debug("%s snd_win %d rcv_win %d\n",
-		 __func__, csk->snd_win, csk->rcv_win);
+	target_debug("%s snd_win %d rcv_win %d\n", __func__, csk->snd_win, csk->rcv_win);
 }
 
 #ifdef CONFIG_CHELSIO_T4_DCB
@@ -889,7 +883,7 @@ static u8 cxgbit_get_iscsi_dcb_priority(struct net_device *ndev, u16 local_port)
 		ret = dcb_getapp(ndev, &iscsi_dcb_app);
 	}
 
-	pr_info("iSCSI priority is set to %u\n", cxgbit_select_priority(ret));
+	target_info("iSCSI priority is set to %u\n", cxgbit_select_priority(ret));
 
 	return cxgbit_select_priority(ret);
 }
@@ -1001,7 +995,7 @@ int cxgbit_ofld_send(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	if (!test_bit(CDEV_STATE_UP, &cdev->flags)) {
 		kfree_skb(skb);
-		pr_err("%s - device not up - dropping\n", __func__);
+		target_err("%s - device not up - dropping\n", __func__);
 		return -EIO;
 	}
 
@@ -1032,7 +1026,7 @@ cxgbit_l2t_send(struct cxgbit_device *cdev, struct sk_buff *skb,
 
 	if (!test_bit(CDEV_STATE_UP, &cdev->flags)) {
 		kfree_skb(skb);
-		pr_err("%s - device not up - dropping\n", __func__);
+		target_err("%s - device not up - dropping\n", __func__);
 		return -EIO;
 	}
 
@@ -1140,7 +1134,7 @@ cxgbit_pass_accept_rpl(struct cxgbit_sock *csk, struct cpl_pass_accept_req *req)
 	u32 wscale;
 	u32 win;
 
-	pr_debug("%s csk %p tid %u\n", __func__, csk, csk->tid);
+	target_debug("%s csk %p tid %u\n", __func__, csk, csk->tid);
 
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
@@ -1231,26 +1225,22 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 	int ret;
 	int iptype;
 
-	pr_debug("%s: cdev = %p; stid = %u; tid = %u\n",
-		 __func__, cdev, stid, tid);
+	target_debug("%s: cdev = %p; stid = %u; tid = %u\n", __func__, cdev, stid, tid);
 
 	cnp = lookup_stid(t, stid);
 	if (!cnp) {
-		pr_err("%s connect request on invalid stid %d\n",
-		       __func__, stid);
+		target_err("%s connect request on invalid stid %d\n", __func__, stid);
 		goto rel_skb;
 	}
 
 	if (cnp->com.state != CSK_STATE_LISTEN) {
-		pr_err("%s - listening parent not in CSK_STATE_LISTEN\n",
-		       __func__);
+		target_err("%s - listening parent not in CSK_STATE_LISTEN\n", __func__);
 		goto reject;
 	}
 
 	csk = lookup_tid(t, tid);
 	if (csk) {
-		pr_err("%s csk not null tid %u\n",
-		       __func__, tid);
+		target_err("%s csk not null tid %u\n", __func__, tid);
 		goto rel_skb;
 	}
 
@@ -1259,22 +1249,20 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	/* Find output route */
 	if (iptype == 4)  {
-		pr_debug("%s parent sock %p tid %u laddr %pI4 raddr %pI4 "
-			 "lport %d rport %d peer_mss %d\n"
-			 , __func__, cnp, tid,
-			 local_ip, peer_ip, ntohs(local_port),
-			 ntohs(peer_port), peer_mss);
+		target_debug("%s parent sock %p tid %u laddr %pI4 raddr %pI4 "
+			     "lport %d rport %d peer_mss %d\n",
+			     __func__, cnp, tid, local_ip, peer_ip, ntohs(local_port),
+			     ntohs(peer_port), peer_mss);
 		dst = cxgb_find_route(&cdev->lldi, cxgbit_get_real_dev,
 				      *(__be32 *)local_ip,
 				      *(__be32 *)peer_ip,
 				      local_port, peer_port,
 				      PASS_OPEN_TOS_G(ntohl(req->tos_stid)));
 	} else {
-		pr_debug("%s parent sock %p tid %u laddr %pI6 raddr %pI6 "
-			 "lport %d rport %d peer_mss %d\n"
-			 , __func__, cnp, tid,
-			 local_ip, peer_ip, ntohs(local_port),
-			 ntohs(peer_port), peer_mss);
+		target_debug("%s parent sock %p tid %u laddr %pI6 raddr %pI6 "
+			     "lport %d rport %d peer_mss %d\n",
+			     __func__, cnp, tid, local_ip, peer_ip, ntohs(local_port),
+			     ntohs(peer_port), peer_mss);
 		dst = cxgb_find_route6(&cdev->lldi, cxgbit_get_real_dev,
 				       local_ip, peer_ip,
 				       local_port, peer_port,
@@ -1283,8 +1271,7 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 					&cnp->com.local_addr)->sin6_scope_id);
 	}
 	if (!dst) {
-		pr_err("%s - failed to find dst entry!\n",
-		       __func__);
+		target_err("%s - failed to find dst entry!\n", __func__);
 		goto reject;
 	}
 
@@ -1297,8 +1284,7 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 	ret = cxgbit_offload_init(csk, iptype, peer_ip, ntohs(local_port),
 				  dst, cdev);
 	if (ret) {
-		pr_err("%s - failed to allocate l2t entry!\n",
-		       __func__);
+		target_err("%s - failed to allocate l2t entry!\n", __func__);
 		dst_release(dst);
 		kfree(csk);
 		goto reject;
@@ -1469,17 +1455,17 @@ u32 cxgbit_send_tx_flowc_wr(struct cxgbit_sock *csk)
 #ifdef CONFIG_CHELSIO_T4_DCB
 	flowc->mnemval[index].mnemonic = FW_FLOWC_MNEM_DCBPRIO;
 	if (vlan == VLAN_NONE) {
-		pr_warn("csk %u without VLAN Tag on DCB Link\n", csk->tid);
+		target_warn("csk %u without VLAN Tag on DCB Link\n", csk->tid);
 		flowc->mnemval[index].val = cpu_to_be32(0);
 	} else
 		flowc->mnemval[index].val = cpu_to_be32(
 				(vlan & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT);
 #endif
 
-	pr_debug("%s: csk %p; tx_chan = %u; rss_qid = %u; snd_seq = %u;"
-		 " rcv_seq = %u; snd_win = %u; emss = %u\n",
-		 __func__, csk, csk->tx_chan, csk->rss_qid, csk->snd_nxt,
-		 csk->rcv_nxt, csk->snd_win, csk->emss);
+	target_debug("%s: csk %p; tx_chan = %u; rss_qid = %u; snd_seq = %u;"
+		     " rcv_seq = %u; snd_win = %u; emss = %u\n",
+		     __func__, csk, csk->tx_chan, csk->rss_qid, csk->snd_nxt, csk->rcv_nxt,
+		     csk->snd_win, csk->emss);
 	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->txq_idx);
 	cxgbit_ofld_send(csk->com.cdev, skb);
 	return flowclen16;
@@ -1491,8 +1477,8 @@ cxgbit_send_tcb_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 	spin_lock_bh(&csk->lock);
 	if (unlikely(csk->com.state != CSK_STATE_ESTABLISHED)) {
 		spin_unlock_bh(&csk->lock);
-		pr_err("%s: csk 0x%p, tid %u, state %u\n",
-		       __func__, csk, csk->tid, csk->com.state);
+		target_err("%s: csk 0x%p, tid %u, state %u\n", __func__, csk, csk->tid,
+			   csk->com.state);
 		__kfree_skb(skb);
 		return -1;
 	}
@@ -1583,11 +1569,10 @@ cxgbit_pass_open_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
 	unsigned int stid = GET_TID(rpl);
 	struct cxgbit_np *cnp = lookup_stid(t, stid);
 
-	pr_debug("%s: cnp = %p; stid = %u; status = %d\n",
-		 __func__, cnp, stid, rpl->status);
+	target_debug("%s: cnp = %p; stid = %u; status = %d\n", __func__, cnp, stid, rpl->status);
 
 	if (!cnp) {
-		pr_info("%s stid %d lookup failure\n", __func__, stid);
+		target_info("%s stid %d lookup failure\n", __func__, stid);
 		goto rel_skb;
 	}
 
@@ -1605,11 +1590,10 @@ cxgbit_close_listsrv_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
 	unsigned int stid = GET_TID(rpl);
 	struct cxgbit_np *cnp = lookup_stid(t, stid);
 
-	pr_debug("%s: cnp = %p; stid = %u; status = %d\n",
-		 __func__, cnp, stid, rpl->status);
+	target_debug("%s: cnp = %p; stid = %u; status = %d\n", __func__, cnp, stid, rpl->status);
 
 	if (!cnp) {
-		pr_info("%s stid %d lookup failure\n", __func__, stid);
+		target_info("%s stid %d lookup failure\n", __func__, stid);
 		goto rel_skb;
 	}
 
@@ -1633,13 +1617,12 @@ cxgbit_pass_establish(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		pr_err("can't find connection for tid %u.\n", tid);
+		target_err("can't find connection for tid %u.\n", tid);
 		goto rel_skb;
 	}
 	cnp = csk->cnp;
 
-	pr_debug("%s: csk %p; tid %u; cnp %p\n",
-		 __func__, csk, tid, cnp);
+	target_debug("%s: csk %p; tid %u; cnp %p\n", __func__, csk, tid, cnp);
 
 	csk->write_seq = snd_isn;
 	csk->snd_una = snd_isn;
@@ -1670,8 +1653,7 @@ static void cxgbit_queue_rx_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 static void cxgbit_peer_close(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
-	pr_debug("%s: csk %p; tid %u; state %d\n",
-		 __func__, csk, csk->tid, csk->com.state);
+	target_debug("%s: csk %p; tid %u; state %d\n", __func__, csk, csk->tid, csk->com.state);
 
 	switch (csk->com.state) {
 	case CSK_STATE_ESTABLISHED:
@@ -1689,8 +1671,7 @@ static void cxgbit_peer_close(struct cxgbit_sock *csk, struct sk_buff *skb)
 	case CSK_STATE_ABORTING:
 		break;
 	default:
-		pr_info("%s: cpl_peer_close in bad state %d\n",
-			__func__, csk->com.state);
+		target_info("%s: cpl_peer_close in bad state %d\n", __func__, csk->com.state);
 	}
 
 	__kfree_skb(skb);
@@ -1698,8 +1679,7 @@ static void cxgbit_peer_close(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 static void cxgbit_close_con_rpl(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
-	pr_debug("%s: csk %p; tid %u; state %d\n",
-		 __func__, csk, csk->tid, csk->com.state);
+	target_debug("%s: csk %p; tid %u; state %d\n", __func__, csk, csk->tid, csk->com.state);
 
 	switch (csk->com.state) {
 	case CSK_STATE_CLOSING:
@@ -1713,8 +1693,7 @@ static void cxgbit_close_con_rpl(struct cxgbit_sock *csk, struct sk_buff *skb)
 	case CSK_STATE_DEAD:
 		break;
 	default:
-		pr_info("%s: cpl_close_con_rpl in bad state %d\n",
-			__func__, csk->com.state);
+		target_info("%s: cpl_close_con_rpl in bad state %d\n", __func__, csk->com.state);
 	}
 
 	__kfree_skb(skb);
@@ -1729,12 +1708,10 @@ static void cxgbit_abort_req_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
 	bool wakeup_thread = false;
 	u32 len = roundup(sizeof(struct cpl_abort_rpl), 16);
 
-	pr_debug("%s: csk %p; tid %u; state %d\n",
-		 __func__, csk, tid, csk->com.state);
+	target_debug("%s: csk %p; tid %u; state %d\n", __func__, csk, tid, csk->com.state);
 
 	if (cxgb_is_neg_adv(hdr->status)) {
-		pr_err("%s: got neg advise %d on tid %u\n",
-		       __func__, hdr->status, tid);
+		target_err("%s: got neg advise %d on tid %u\n", __func__, hdr->status, tid);
 		goto rel_skb;
 	}
 
@@ -1756,8 +1733,7 @@ static void cxgbit_abort_req_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
 	case CSK_STATE_ABORTING:
 		break;
 	default:
-		pr_info("%s: cpl_abort_req_rss in bad state %d\n",
-			__func__, csk->com.state);
+		target_info("%s: cpl_abort_req_rss in bad state %d\n", __func__, csk->com.state);
 		csk->com.state = CSK_STATE_DEAD;
 	}
 
@@ -1786,8 +1762,7 @@ static void cxgbit_abort_rpl_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
 	struct cpl_abort_rpl_rss *rpl = cplhdr(skb);
 
-	pr_debug("%s: csk %p; tid %u; state %d\n",
-		 __func__, csk, csk->tid, csk->com.state);
+	target_debug("%s: csk %p; tid %u; state %d\n", __func__, csk, csk->tid, csk->com.state);
 
 	switch (csk->com.state) {
 	case CSK_STATE_ABORTING:
@@ -1798,8 +1773,7 @@ static void cxgbit_abort_rpl_rss(struct cxgbit_sock *csk, struct sk_buff *skb)
 		cxgbit_put_csk(csk);
 		break;
 	default:
-		pr_info("%s: cpl_abort_rpl_rss in state %d\n",
-			__func__, csk->com.state);
+		target_info("%s: cpl_abort_rpl_rss in state %d\n", __func__, csk->com.state);
 	}
 
 	__kfree_skb(skb);
@@ -1811,8 +1785,8 @@ static bool cxgbit_credit_err(const struct cxgbit_sock *csk)
 	u32 credit = 0;
 
 	if (unlikely(csk->wr_cred > csk->wr_max_cred)) {
-		pr_err("csk 0x%p, tid %u, credit %u > %u\n",
-		       csk, csk->tid, csk->wr_cred, csk->wr_max_cred);
+		target_err("csk 0x%p, tid %u, credit %u > %u\n", csk, csk->tid, csk->wr_cred,
+			   csk->wr_max_cred);
 		return true;
 	}
 
@@ -1822,9 +1796,8 @@ static bool cxgbit_credit_err(const struct cxgbit_sock *csk)
 	}
 
 	if (unlikely((csk->wr_cred + credit) != csk->wr_max_cred)) {
-		pr_err("csk 0x%p, tid %u, credit %u + %u != %u.\n",
-		       csk, csk->tid, csk->wr_cred,
-		       credit, csk->wr_max_cred);
+		target_err("csk 0x%p, tid %u, credit %u + %u != %u.\n", csk, csk->tid, csk->wr_cred,
+			   credit, csk->wr_max_cred);
 
 		return true;
 	}
@@ -1847,18 +1820,15 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 		u32 csum;
 
 		if (unlikely(!p)) {
-			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
-			       csk, csk->tid, credits,
-			       csk->wr_cred, csk->wr_una_cred);
+			target_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n", csk, csk->tid, credits,
+				   csk->wr_cred, csk->wr_una_cred);
 			break;
 		}
 
 		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
-			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
-				csk,  csk->tid,
-				credits, csk->wr_cred, csk->wr_una_cred,
-				csum);
+			target_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n", csk, csk->tid, credits,
+				    csk->wr_cred, csk->wr_una_cred, csum);
 			p->csum = (__force __wsum)(csum - credits);
 			break;
 		}
@@ -1875,9 +1845,8 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	if (rpl->seq_vld & CPL_FW4_ACK_FLAGS_SEQVAL) {
 		if (unlikely(before(snd_una, csk->snd_una))) {
-			pr_warn("csk 0x%p,%u, snd_una %u/%u.",
-				csk, csk->tid, snd_una,
-				csk->snd_una);
+			target_warn("csk 0x%p,%u, snd_una %u/%u.", csk, csk->tid, snd_una,
+				    csk->snd_una);
 			goto rel_skb;
 		}
 
@@ -1904,7 +1873,7 @@ static void cxgbit_set_tcb_rpl(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		pr_err("can't find connection for tid %u.\n", tid);
+		target_err("can't find connection for tid %u.\n", tid);
 		goto rel_skb;
 	} else {
 		cxgbit_wake_up(&csk->com.wr_wait, __func__, rpl->status);
@@ -1925,7 +1894,7 @@ static void cxgbit_rx_data(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		pr_err("can't find conn. for tid %u.\n", tid);
+		target_err("can't find conn. for tid %u.\n", tid);
 		goto rel_skb;
 	}
 
@@ -1989,7 +1958,7 @@ static void cxgbit_rx_cpl(struct cxgbit_device *cdev, struct sk_buff *skb)
 
 	csk = lookup_tid(t, tid);
 	if (unlikely(!csk)) {
-		pr_err("can't find conn. for tid %u.\n", tid);
+		target_err("can't find conn. for tid %u.\n", tid);
 		goto rel_skb;
 	}
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 17fd0d8cc490..3fd56f1484d8 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -179,9 +179,8 @@ cxgbit_ddp_reserve(struct cxgbit_sock *csk, struct cxgbi_task_tag_info *ttinfo,
 	int ret;
 
 	if ((xferlen < DDP_THRESHOLD) || (!sgcnt)) {
-		pr_debug("ppm 0x%p, pgidx %u, xfer %u, sgcnt %u, NO ddp.\n",
-			 ppm, ppm->tformat.pgsz_idx_dflt,
-			 xferlen, ttinfo->nents);
+		target_debug("ppm 0x%p, pgidx %u, xfer %u, sgcnt %u, NO ddp.\n", ppm,
+			     ppm->tformat.pgsz_idx_dflt, xferlen, ttinfo->nents);
 		return -EINVAL;
 	}
 
@@ -204,8 +203,8 @@ cxgbit_ddp_reserve(struct cxgbit_sock *csk, struct cxgbi_task_tag_info *ttinfo,
 	ret = dma_map_sg(&ppm->pdev->dev, sgl, sgcnt, DMA_FROM_DEVICE);
 	sgl->offset = sg_offset;
 	if (!ret) {
-		pr_debug("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
-			 __func__, 0, xferlen, sgcnt);
+		target_debug("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n", __func__, 0, xferlen,
+			     sgcnt);
 		goto rel_ppods;
 	}
 
@@ -247,8 +246,8 @@ cxgbit_get_r2t_ttt(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
 	if (ret < 0) {
-		pr_debug("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
-			 csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
+		target_debug("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n", csk, cmd,
+			     cmd->se_cmd.data_length, ttinfo->nents);
 
 		ttinfo->sgl = NULL;
 		ttinfo->nents = 0;
@@ -256,7 +255,7 @@ cxgbit_get_r2t_ttt(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		ccmd->release = true;
 	}
 out:
-	pr_debug("cdev 0x%p, cmd 0x%p, tag 0x%x\n", cdev, cmd, ttinfo->tag);
+	target_debug("cdev 0x%p, cmd 0x%p, tag 0x%x\n", cdev, cmd, ttinfo->tag);
 	r2t->targ_xfer_tag = ttinfo->tag;
 }
 
@@ -301,7 +300,7 @@ int cxgbit_ddp_init(struct cxgbit_device *cdev)
 	int ret, i;
 
 	if (!lldi->vr->iscsi.size) {
-		pr_warn("%s, iscsi NOT enabled, check config!\n", ndev->name);
+		target_warn("%s, iscsi NOT enabled, check config!\n", ndev->name);
 		return -EACCES;
 	}
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index 2c1950df3b3e..4e8097002679 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -74,8 +74,7 @@ static void *cxgbit_uld_add(const struct cxgb4_lld_info *lldi)
 	}
 
 	if (!test_bit(CDEV_DDP_ENABLE, &cdev->flags))
-		pr_info("cdev %s ddp init failed\n",
-			pci_name(lldi->pdev));
+		target_info("cdev %s ddp init failed\n", pci_name(lldi->pdev));
 
 	if (lldi->fw_vers >= 0x10d2b00)
 		set_bit(CDEV_ISO_ENABLE, &cdev->flags);
@@ -87,8 +86,7 @@ static void *cxgbit_uld_add(const struct cxgb4_lld_info *lldi)
 	list_add_tail(&cdev->list, &cdev_list_head);
 	mutex_unlock(&cdev_list_lock);
 
-	pr_info("cdev %s added for iSCSI target transport\n",
-		pci_name(lldi->pdev));
+	target_info("cdev %s added for iSCSI target transport\n", pci_name(lldi->pdev));
 
 	return cdev;
 }
@@ -146,24 +144,23 @@ static int cxgbit_uld_state_change(void *handle, enum cxgb4_state state)
 	switch (state) {
 	case CXGB4_STATE_UP:
 		set_bit(CDEV_STATE_UP, &cdev->flags);
-		pr_info("cdev %s state UP.\n", pci_name(cdev->lldi.pdev));
+		target_info("cdev %s state UP.\n", pci_name(cdev->lldi.pdev));
 		break;
 	case CXGB4_STATE_START_RECOVERY:
 		clear_bit(CDEV_STATE_UP, &cdev->flags);
 		cxgbit_close_conn(cdev);
-		pr_info("cdev %s state RECOVERY.\n", pci_name(cdev->lldi.pdev));
+		target_info("cdev %s state RECOVERY.\n", pci_name(cdev->lldi.pdev));
 		break;
 	case CXGB4_STATE_DOWN:
-		pr_info("cdev %s state DOWN.\n", pci_name(cdev->lldi.pdev));
+		target_info("cdev %s state DOWN.\n", pci_name(cdev->lldi.pdev));
 		break;
 	case CXGB4_STATE_DETACH:
 		clear_bit(CDEV_STATE_UP, &cdev->flags);
-		pr_info("cdev %s state DETACH.\n", pci_name(cdev->lldi.pdev));
+		target_info("cdev %s state DETACH.\n", pci_name(cdev->lldi.pdev));
 		cxgbit_detach_cdev(cdev);
 		break;
 	default:
-		pr_info("cdev %s unknown state %d.\n",
-			pci_name(cdev->lldi.pdev), state);
+		target_info("cdev %s unknown state %d.\n", pci_name(cdev->lldi.pdev), state);
 		break;
 	}
 	return 0;
@@ -175,17 +172,17 @@ cxgbit_process_ddpvld(struct cxgbit_sock *csk, struct cxgbit_lro_pdu_cb *pdu_cb,
 {
 
 	if (ddpvld & (1 << CPL_RX_ISCSI_DDP_STATUS_HCRC_SHIFT)) {
-		pr_info("tid 0x%x, status 0x%x, hcrc bad.\n", csk->tid, ddpvld);
+		target_info("tid 0x%x, status 0x%x, hcrc bad.\n", csk->tid, ddpvld);
 		pdu_cb->flags |= PDUCBF_RX_HCRC_ERR;
 	}
 
 	if (ddpvld & (1 << CPL_RX_ISCSI_DDP_STATUS_DCRC_SHIFT)) {
-		pr_info("tid 0x%x, status 0x%x, dcrc bad.\n", csk->tid, ddpvld);
+		target_info("tid 0x%x, status 0x%x, dcrc bad.\n", csk->tid, ddpvld);
 		pdu_cb->flags |= PDUCBF_RX_DCRC_ERR;
 	}
 
 	if (ddpvld & (1 << CPL_RX_ISCSI_DDP_STATUS_PAD_SHIFT))
-		pr_info("tid 0x%x, status 0x%x, pad bad.\n", csk->tid, ddpvld);
+		target_info("tid 0x%x, status 0x%x, pad bad.\n", csk->tid, ddpvld);
 
 	if ((ddpvld & (1 << CPL_RX_ISCSI_DDP_STATUS_DDP_SHIFT)) &&
 	    (!(pdu_cb->flags & PDUCBF_RX_DATA))) {
@@ -384,7 +381,7 @@ cxgbit_lro_receive(struct cxgbit_sock *csk, u8 op, const __be64 *rsp,
 	struct cxgbit_lro_cb *lro_cb;
 
 	if (!csk) {
-		pr_err("%s: csk NULL, op 0x%x.\n", __func__, op);
+		target_err("%s: csk NULL, op 0x%x.\n", __func__, op);
 		goto out;
 	}
 
@@ -488,10 +485,8 @@ cxgbit_uld_lro_rx_handler(void *hndl, const __be64 *rsp,
 		skb_copy_to_linear_data(skb, &rsp[1], len);
 	} else {
 		if (unlikely(op != *(u8 *)gl->va)) {
-			pr_info("? FL 0x%p,RSS%#llx,FL %#llx,len %u.\n",
-				gl->va, be64_to_cpu(*rsp),
-				get_unaligned_be64(gl->va),
-				gl->tot_len);
+			target_info("? FL 0x%p,RSS%#llx,FL %#llx,len %u.\n", gl->va,
+				    be64_to_cpu(*rsp), get_unaligned_be64(gl->va), gl->tot_len);
 			return 0;
 		}
 
@@ -512,19 +507,18 @@ cxgbit_uld_lro_rx_handler(void *hndl, const __be64 *rsp,
 	op = rpl->ot.opcode;
 	cxgbit_skcb_rx_opcode(skb) = op;
 
-	pr_debug("cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
-		 cdev, op, rpl->ot.opcode_tid,
-		 ntohl(rpl->ot.opcode_tid), skb);
+	target_debug("cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n", cdev, op, rpl->ot.opcode_tid,
+		     ntohl(rpl->ot.opcode_tid), skb);
 
 	if (op < NUM_CPL_CMDS && cxgbit_cplhandlers[op]) {
 		cxgbit_cplhandlers[op](cdev, skb);
 	} else {
-		pr_err("No handler for opcode 0x%x.\n", op);
+		target_err("No handler for opcode 0x%x.\n", op);
 		__kfree_skb(skb);
 	}
 	return 0;
 nomem:
-	pr_err("%s OOM bailing out.\n", __func__);
+	target_err("%s OOM bailing out.\n", __func__);
 	return 1;
 }
 
@@ -614,8 +608,7 @@ static void cxgbit_dcb_workfn(struct work_struct *work)
 		goto out;
 	}
 
-	pr_debug("priority for ifid %d is %u\n",
-		 iscsi_app->ifindex, priority);
+	target_debug("priority for ifid %d is %u\n", iscsi_app->ifindex, priority);
 
 	ndev = dev_get_by_index(&init_net, iscsi_app->ifindex);
 
@@ -712,7 +705,7 @@ static int __init cxgbit_init(void)
 	iscsit_register_transport(&cxgbit_transport);
 
 #ifdef CONFIG_CHELSIO_T4_DCB
-	pr_info("%s dcb enabled.\n", DRV_NAME);
+	target_info("%s dcb enabled.\n", DRV_NAME);
 	register_dcbevent_notifier(&cxgbit_dcbevent_nb);
 #endif
 	BUILD_BUG_ON(sizeof_field(struct sk_buff, cb) <
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index acfc39683c87..c49d3d975c80 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -235,9 +235,8 @@ void cxgbit_push_tx_frames(struct cxgbit_sock *csk)
 		}
 
 		if (csk->wr_cred < credits_needed) {
-			pr_debug("csk 0x%p, skb %u/%u, wr %d < %u.\n",
-				 csk, skb->len, skb->data_len,
-				 credits_needed, csk->wr_cred);
+			target_debug("csk 0x%p, skb %u/%u, wr %d < %u.\n", csk, skb->len,
+				     skb->data_len, credits_needed, csk->wr_cred);
 			break;
 		}
 		__skb_unlink(skb, &csk->txq);
@@ -246,9 +245,8 @@ void cxgbit_push_tx_frames(struct cxgbit_sock *csk)
 		csk->wr_cred -= credits_needed;
 		csk->wr_una_cred += credits_needed;
 
-		pr_debug("csk 0x%p, skb %u/%u, wr %d, left %u, unack %u.\n",
-			 csk, skb->len, skb->data_len, credits_needed,
-			 csk->wr_cred, csk->wr_una_cred);
+		target_debug("csk 0x%p, skb %u/%u, wr %d, left %u, unack %u.\n", csk, skb->len,
+			     skb->data_len, credits_needed, csk->wr_cred, csk->wr_una_cred);
 
 		if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_NEED_HDR)) {
 			len += cxgbit_skcb_tx_extralen(skb);
@@ -276,8 +274,7 @@ void cxgbit_push_tx_frames(struct cxgbit_sock *csk)
 		t4_set_arp_err_handler(skb, csk,
 				       cxgbit_arp_failure_skb_discard);
 
-		pr_debug("csk 0x%p,%u, skb 0x%p, %u.\n",
-			 csk, csk->tid, skb, len);
+		target_debug("csk 0x%p,%u, skb 0x%p, %u.\n", csk, csk->tid, skb, len);
 
 		cxgbit_l2t_send(csk->com.cdev, skb, csk->l2t);
 	}
@@ -600,7 +597,7 @@ static int cxgbit_set_digest(struct cxgbit_sock *csk)
 
 	param = iscsi_find_param_from_key(HEADERDIGEST, conn->param_list);
 	if (!param) {
-		pr_err("param not found key %s\n", HEADERDIGEST);
+		target_err("param not found key %s\n", HEADERDIGEST);
 		return -1;
 	}
 
@@ -610,7 +607,7 @@ static int cxgbit_set_digest(struct cxgbit_sock *csk)
 	param = iscsi_find_param_from_key(DATADIGEST, conn->param_list);
 	if (!param) {
 		csk->submode = 0;
-		pr_err("param not found key %s\n", DATADIGEST);
+		target_err("param not found key %s\n", DATADIGEST);
 		return -1;
 	}
 
@@ -638,7 +635,7 @@ static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
 		param = iscsi_find_param_from_key(MAXBURSTLENGTH,
 						  conn->param_list);
 		if (!param) {
-			pr_err("param not found key %s\n", MAXBURSTLENGTH);
+			target_err("param not found key %s\n", MAXBURSTLENGTH);
 			return -1;
 		}
 
@@ -685,7 +682,7 @@ static int cxgbit_seq_pdu_inorder(struct cxgbit_sock *csk)
 		param = iscsi_find_param_from_key(DATASEQUENCEINORDER,
 						  conn->param_list);
 		if (!param) {
-			pr_err("param not found key %s\n", DATASEQUENCEINORDER);
+			target_err("param not found key %s\n", DATASEQUENCEINORDER);
 			return -1;
 		}
 
@@ -695,7 +692,7 @@ static int cxgbit_seq_pdu_inorder(struct cxgbit_sock *csk)
 		param = iscsi_find_param_from_key(DATAPDUINORDER,
 						  conn->param_list);
 		if (!param) {
-			pr_err("param not found key %s\n", DATAPDUINORDER);
+			target_err("param not found key %s\n", DATAPDUINORDER);
 			return -1;
 		}
 
@@ -731,7 +728,7 @@ static int cxgbit_set_params(struct iscsit_conn *conn)
 		param = iscsi_find_param_from_key(ERRORRECOVERYLEVEL,
 						  conn->param_list);
 		if (!param) {
-			pr_err("param not found key %s\n", ERRORRECOVERYLEVEL);
+			target_err("param not found key %s\n", ERRORRECOVERYLEVEL);
 			return -1;
 		}
 		if (kstrtou8(param->value, 0, &erl) < 0)
@@ -841,7 +838,7 @@ static struct iscsit_cmd *cxgbit_allocate_cmd(struct cxgbit_sock *csk)
 
 	cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
 	if (!cmd) {
-		pr_err("Unable to allocate iscsit_cmd + cxgbit_cmd\n");
+		target_err("Unable to allocate iscsit_cmd + cxgbit_cmd\n");
 		return NULL;
 	}
 
@@ -861,11 +858,11 @@ cxgbit_handle_immediate_data(struct iscsit_cmd *cmd, struct iscsi_scsi_req *hdr,
 	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_rx_pdu_cb(csk->skb);
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
-		pr_err("ImmediateData CRC32C DataDigest error\n");
+		target_err("ImmediateData CRC32C DataDigest error\n");
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " Immediate Data digest failure while"
-			       " in ERL=0.\n");
+			target_err("Unable to recover from"
+				   " Immediate Data digest failure while"
+				   " in ERL=0.\n");
 			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
 					  (unsigned char *)hdr);
 			return IMMEDIATE_DATA_CANNOT_RECOVER;
@@ -1037,19 +1034,17 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 	}
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
-		pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
-		       " DataSN: 0x%08x\n",
-		       hdr->itt, hdr->offset, data_len,
-		       hdr->datasn);
+		target_err("ITT: 0x%08x, Offset: %u, Length: %u,"
+			   " DataSN: 0x%08x\n",
+			   hdr->itt, hdr->offset, data_len, hdr->datasn);
 
 		dcrc_err = true;
 		goto check_payload;
 	}
 
-	pr_debug("DataOut data_len: %u, "
-		"write_data_done: %u, data_length: %u\n",
-		  data_len,  cmd->write_data_done,
-		  cmd->se_cmd.data_length);
+	target_debug("DataOut data_len: %u, "
+		     "write_data_done: %u, data_length: %u\n",
+		     data_len, cmd->write_data_done, cmd->se_cmd.data_length);
 
 	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
 		u32 skip = data_offset % PAGE_SIZE;
@@ -1099,9 +1094,9 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " NOPOUT Ping DataCRC failure while in"
-			       " ERL=0.\n");
+			target_err("Unable to recover from"
+				   " NOPOUT Ping DataCRC failure while in"
+				   " ERL=0.\n");
 			ret = -1;
 			goto out;
 		} else {
@@ -1109,9 +1104,10 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			pr_info("Dropping NOPOUT"
-				" Command CmdSN: 0x%08x due to"
-				" DataCRC error.\n", hdr->cmdsn);
+			target_info("Dropping NOPOUT"
+				    " Command CmdSN: 0x%08x due to"
+				    " DataCRC error.\n",
+				    hdr->cmdsn);
 			ret = 0;
 			goto out;
 		}
@@ -1123,8 +1119,8 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 	if (payload_length && hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
 		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
 		if (!ping_data) {
-			pr_err("Unable to allocate memory for"
-				" NOPOUT ping data.\n");
+			target_err("Unable to allocate memory for"
+				   " NOPOUT ping data.\n");
 			ret = -1;
 			goto out;
 		}
@@ -1139,9 +1135,10 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsit_cmd *cmd
 		cmd->buf_ptr = ping_data;
 		cmd->buf_ptr_size = payload_length;
 
-		pr_debug("Got %u bytes of NOPOUT ping"
-			" data.\n", payload_length);
-		pr_debug("Ping Data: \"%s\"\n", ping_data);
+		target_debug("Got %u bytes of NOPOUT ping"
+			     " data.\n",
+			     payload_length);
+		target_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
 	return iscsit_process_nop_out(conn, cmd, hdr);
@@ -1167,18 +1164,19 @@ cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsit_cmd *cmd)
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " Text Data digest failure while in"
-			       " ERL=0.\n");
+			target_err("Unable to recover from"
+				   " Text Data digest failure while in"
+				   " ERL=0.\n");
 			goto reject;
 		} else {
 			/*
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			pr_info("Dropping Text"
-				" Command CmdSN: 0x%08x due to"
-				" DataCRC error.\n", hdr->cmdsn);
+			target_info("Dropping Text"
+				    " Command CmdSN: 0x%08x due to"
+				    " DataCRC error.\n",
+				    hdr->cmdsn);
 			return 0;
 		}
 	}
@@ -1186,8 +1184,8 @@ cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsit_cmd *cmd)
 	if (payload_length) {
 		text_in = kzalloc(payload_length, GFP_KERNEL);
 		if (!text_in) {
-			pr_err("Unable to allocate text_in of payload_length: %u\n",
-			       payload_length);
+			target_err("Unable to allocate text_in of payload_length: %u\n",
+				   payload_length);
 			return -ENOMEM;
 		}
 		skb_copy_bits(csk->skb, pdu_cb->doffset,
@@ -1270,7 +1268,7 @@ static int cxgbit_target_rx_opcode(struct cxgbit_sock *csk)
 		ret = iscsit_handle_snack(conn, (unsigned char *)hdr);
 		break;
 	default:
-		pr_err("Got unknown iSCSI OpCode: 0x%02x\n", opcode);
+		target_err("Got unknown iSCSI OpCode: 0x%02x\n", opcode);
 		dump_stack();
 		break;
 	}
@@ -1303,8 +1301,9 @@ static int cxgbit_rx_opcode(struct cxgbit_sock *csk)
 	if (conn->sess->sess_ops->SessionType &&
 	    ((!(opcode & ISCSI_OP_TEXT)) ||
 	     (!(opcode & ISCSI_OP_LOGOUT)))) {
-		pr_err("Received illegal iSCSI Opcode: 0x%02x"
-			" while in Discovery Session, rejecting.\n", opcode);
+		target_err("Received illegal iSCSI Opcode: 0x%02x"
+			   " while in Discovery Session, rejecting.\n",
+			   opcode);
 		iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 				  (unsigned char *)hdr);
 		goto transport_err;
@@ -1329,10 +1328,10 @@ static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
 	login_req = (struct iscsi_login_req *)login->req;
 	memcpy(login_req, pdu_cb->hdr, sizeof(*login_req));
 
-	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
-		login_req->flags, login_req->itt, login_req->cmdsn,
-		login_req->exp_statsn, login_req->cid, pdu_cb->dlen);
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
+		     login_req->cid, pdu_cb->dlen);
 	/*
 	 * Setup the initial iscsi_login values from the leading
 	 * login request PDU.
@@ -1388,21 +1387,19 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 	struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, 0);
 	u8 i;
 
-	pr_info("skb 0x%p, head 0x%p, 0x%p, len %u,%u, frags %u.\n",
-		skb, skb->head, skb->data, skb->len, skb->data_len,
-		ssi->nr_frags);
-	pr_info("skb 0x%p, lro_cb, csk 0x%p, pdu %u, %u.\n",
-		skb, lro_cb->csk, lro_cb->pdu_idx, lro_cb->pdu_totallen);
+	target_info("skb 0x%p, head 0x%p, 0x%p, len %u,%u, frags %u.\n", skb, skb->head, skb->data,
+		    skb->len, skb->data_len, ssi->nr_frags);
+	target_info("skb 0x%p, lro_cb, csk 0x%p, pdu %u, %u.\n", skb, lro_cb->csk, lro_cb->pdu_idx,
+		    lro_cb->pdu_totallen);
 
 	for (i = 0; i < lro_cb->pdu_idx; i++, pdu_cb++)
-		pr_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, "
-			"frags %u.\n",
-			skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq,
-			pdu_cb->ddigest, pdu_cb->frags);
+		target_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, "
+			    "frags %u.\n",
+			    skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq, pdu_cb->ddigest,
+			    pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
-		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
-			skb, i, skb_frag_off(&ssi->frags[i]),
-			skb_frag_size(&ssi->frags[i]));
+		target_info("skb 0x%p, frag %d, off %u, sz %u.\n", skb, i,
+			    skb_frag_off(&ssi->frags[i]), skb_frag_size(&ssi->frags[i]));
 }
 
 static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
@@ -1539,8 +1536,8 @@ static int cxgbit_t5_rx_lro_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	if ((pdu_cb->flags & PDUCBF_RX_HDR) &&
 	    (pdu_cb->seq != csk->rcv_nxt)) {
-		pr_info("csk 0x%p, tid 0x%x, seq 0x%x != 0x%x.\n",
-			csk, csk->tid, pdu_cb->seq, csk->rcv_nxt);
+		target_info("csk 0x%p, tid 0x%x, seq 0x%x != 0x%x.\n", csk, csk->tid, pdu_cb->seq,
+			    csk->rcv_nxt);
 		cxgbit_lro_skb_dump(skb);
 		return ret;
 	}
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1d25e64b068a..5c0482ba3da5 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -116,8 +116,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	int ret;
 
 	if (strlen(buf) >= ISCSI_IQN_LEN) {
-		pr_err("Target IQN exceeds %d bytes\n",
-				ISCSI_IQN_LEN);
+		target_err("Target IQN exceeds %d bytes\n", ISCSI_IQN_LEN);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -141,7 +140,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 
 	ret = idr_alloc(&tiqn_idr, NULL, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
-		pr_err("idr_alloc() failed for tiqn->tiqn_index\n");
+		target_err("idr_alloc() failed for tiqn->tiqn_index\n");
 		spin_unlock(&tiqn_lock);
 		idr_preload_end();
 		kfree(tiqn);
@@ -153,7 +152,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_unlock(&tiqn_lock);
 	idr_preload_end();
 
-	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
+	target_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
 	return tiqn;
 
@@ -182,7 +181,7 @@ void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
 	 * fabric and control code paths.
 	 */
 	if (iscsit_set_tiqn_shutdown(tiqn) < 0) {
-		pr_err("iscsit_set_tiqn_shutdown() failed\n");
+		target_err("iscsit_set_tiqn_shutdown() failed\n");
 		return;
 	}
 
@@ -193,8 +192,7 @@ void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
 	idr_remove(&tiqn_idr, tiqn->tiqn_index);
 	spin_unlock(&tiqn_lock);
 
-	pr_debug("CORE[0] - Deleted iSCSI Target IQN: %s\n",
-			tiqn->tiqn);
+	target_debug("CORE[0] - Deleted iSCSI Target IQN: %s\n", tiqn->tiqn);
 	kfree(tiqn);
 }
 
@@ -373,7 +371,7 @@ struct iscsi_np *iscsit_add_np(
 
 	np->np_thread = kthread_run(iscsi_target_login_thread, np, "iscsi_np");
 	if (IS_ERR(np->np_thread)) {
-		pr_err("Unable to create kthread: iscsi_np\n");
+		target_err("Unable to create kthread: iscsi_np\n");
 		ret = PTR_ERR(np->np_thread);
 		kfree(np);
 		mutex_unlock(&np_lock);
@@ -392,8 +390,8 @@ struct iscsi_np *iscsit_add_np(
 	list_add_tail(&np->np_list, &g_np_list);
 	mutex_unlock(&np_lock);
 
-	pr_debug("CORE[0] - Added Network Portal: %pISpc on %s\n",
-		&np->np_sockaddr, np->np_transport->name);
+	target_debug("CORE[0] - Added Network Portal: %pISpc on %s\n", &np->np_sockaddr,
+		     np->np_transport->name);
 
 	return np;
 }
@@ -463,8 +461,8 @@ int iscsit_del_np(struct iscsi_np *np)
 	list_del(&np->np_list);
 	mutex_unlock(&np_lock);
 
-	pr_debug("CORE[0] - Removed Network Portal: %pISpc on %s\n",
-		&np->np_sockaddr, np->np_transport->name);
+	target_debug("CORE[0] - Removed Network Portal: %pISpc on %s\n", &np->np_sockaddr,
+		     np->np_transport->name);
 
 	iscsit_put_transport(np->np_transport);
 	kfree(np);
@@ -516,9 +514,9 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
-		pr_debug("Attaching CRC32C HeaderDigest"
-			 " to opcode 0x%x 0x%08x\n",
-			 hdr->opcode, *header_digest);
+		target_debug("Attaching CRC32C HeaderDigest"
+			     " to opcode 0x%x 0x%08x\n",
+			     hdr->opcode, *header_digest);
 	}
 
 	if (data_buf_len) {
@@ -532,8 +530,9 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			iov[niov].iov_base = &cmd->pad_bytes;
 			iov[niov++].iov_len = padding;
 			tx_size += padding;
-			pr_debug("Attaching %u additional"
-				 " padding bytes.\n", padding);
+			target_debug("Attaching %u additional"
+				     " padding bytes.\n",
+				     padding);
 		}
 
 		if (conn->conn_ops->DataDigest) {
@@ -545,9 +544,9 @@ iscsit_xmit_nondatain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			iov[niov].iov_base = &cmd->data_crc;
 			iov[niov++].iov_len = ISCSI_CRC_LEN;
 			tx_size += ISCSI_CRC_LEN;
-			pr_debug("Attached DataDigest for %u"
-				 " bytes opcode 0x%x, CRC 0x%08x\n",
-				 data_buf_len, hdr->opcode, cmd->data_crc);
+			target_debug("Attached DataDigest for %u"
+				     " bytes opcode 0x%x, CRC 0x%08x\n",
+				     data_buf_len, hdr->opcode, cmd->data_crc);
 		}
 	}
 
@@ -591,8 +590,8 @@ iscsit_xmit_datain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
 
-		pr_debug("Attaching CRC32 HeaderDigest for DataIN PDU 0x%08x\n",
-			 *header_digest);
+		target_debug("Attaching CRC32 HeaderDigest for DataIN PDU 0x%08x\n",
+			     *header_digest);
 	}
 
 	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[iov_count],
@@ -610,7 +609,7 @@ iscsit_xmit_datain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		iov[iov_count++].iov_len	= cmd->padding;
 		tx_size += cmd->padding;
 
-		pr_debug("Attaching %u padding bytes\n", cmd->padding);
+		target_debug("Attaching %u padding bytes\n", cmd->padding);
 	}
 
 	if (conn->conn_ops->DataDigest) {
@@ -624,8 +623,8 @@ iscsit_xmit_datain_pdu(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
 
-		pr_debug("Attached CRC32C DataDigest %d bytes, crc 0x%08x\n",
-			 datain->length + cmd->padding, cmd->data_crc);
+		target_debug("Attached CRC32C DataDigest %d bytes, crc 0x%08x\n",
+			     datain->length + cmd->padding, cmd->data_crc);
 	}
 
 	cmd->iov_data_count = iov_count;
@@ -683,7 +682,7 @@ static int __init iscsi_target_init_module(void)
 {
 	int ret = 0, size;
 
-	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
+	target_debug("iSCSI-Target " ISCSIT_VERSION "\n");
 	iscsit_global = kzalloc(sizeof(*iscsit_global), GFP_KERNEL);
 	if (!iscsit_global)
 		return -1;
@@ -702,7 +701,7 @@ static int __init iscsi_target_init_module(void)
 		goto configfs_out;
 
 	if (!zalloc_cpumask_var(&iscsit_global->allowed_cpumask, GFP_KERNEL)) {
-		pr_err("Unable to allocate iscsit_global->allowed_cpumask\n");
+		target_err("Unable to allocate iscsit_global->allowed_cpumask\n");
 		goto bitmap_out;
 	}
 	cpumask_setall(iscsit_global->allowed_cpumask);
@@ -711,8 +710,8 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
-		pr_err("Unable to kmem_cache_create() for"
-				" lio_qr_cache\n");
+		target_err("Unable to kmem_cache_create() for"
+			   " lio_qr_cache\n");
 		goto cpumask_out;
 	}
 
@@ -720,8 +719,8 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_datain_req),
 			__alignof__(struct iscsi_datain_req), 0, NULL);
 	if (!lio_dr_cache) {
-		pr_err("Unable to kmem_cache_create() for"
-				" lio_dr_cache\n");
+		target_err("Unable to kmem_cache_create() for"
+			   " lio_dr_cache\n");
 		goto qr_out;
 	}
 
@@ -729,8 +728,8 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_ooo_cmdsn),
 			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
 	if (!lio_ooo_cache) {
-		pr_err("Unable to kmem_cache_create() for"
-				" lio_ooo_cache\n");
+		target_err("Unable to kmem_cache_create() for"
+			   " lio_ooo_cache\n");
 		goto dr_out;
 	}
 
@@ -738,8 +737,8 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
 			0, NULL);
 	if (!lio_r2t_cache) {
-		pr_err("Unable to kmem_cache_create() for"
-				" lio_r2t_cache\n");
+		target_err("Unable to kmem_cache_create() for"
+			   " lio_r2t_cache\n");
 		goto ooo_out;
 	}
 
@@ -810,7 +809,7 @@ int iscsit_add_reject(
 
 	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
+		target_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_free_cmd(cmd, false);
 		return -1;
 	}
@@ -836,8 +835,7 @@ static int iscsit_add_reject_from_cmd(
 	const bool do_put = cmd->se_cmd.se_tfo != NULL;
 
 	if (!cmd->conn) {
-		pr_err("cmd->conn is NULL for ITT: 0x%08x\n",
-				cmd->init_task_tag);
+		target_err("cmd->conn is NULL for ITT: 0x%08x\n", cmd->init_task_tag);
 		return -1;
 	}
 	conn = cmd->conn;
@@ -847,7 +845,7 @@ static int iscsit_add_reject_from_cmd(
 
 	cmd->buf_ptr = kmemdup(buf, ISCSI_HDR_LEN, GFP_KERNEL);
 	if (!cmd->buf_ptr) {
-		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
+		target_err("Unable to allocate memory for cmd->buf_ptr\n");
 		iscsit_free_cmd(cmd, false);
 		return -1;
 	}
@@ -865,7 +863,7 @@ static int iscsit_add_reject_from_cmd(
 	 * scsit_setup_scsi_cmd()
 	 */
 	if (do_put) {
-		pr_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
+		target_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
 		target_put_sess_cmd(&cmd->se_cmd);
 	}
 	return -1;
@@ -903,7 +901,7 @@ static int iscsit_map_iovec(struct iscsit_cmd *cmd, struct kvec *iov, int nvec,
 		return 0;
 
 	if (ent >= cmd->se_cmd.t_data_nents) {
-		pr_err("Initial page entry out-of-bounds\n");
+		target_err("Initial page entry out-of-bounds\n");
 		goto overflow;
 	}
 
@@ -935,12 +933,11 @@ static int iscsit_map_iovec(struct iscsit_cmd *cmd, struct kvec *iov, int nvec,
 	return i;
 
 overflow:
-	pr_err("offset %d + length %d overflow; %d/%d; sg-list:\n",
-	       data_offset, orig_data_length, i, nvec);
+	target_err("offset %d + length %d overflow; %d/%d; sg-list:\n", data_offset,
+		   orig_data_length, i, nvec);
 	for_each_sg(cmd->se_cmd.t_data_sg, sg,
 		    cmd->se_cmd.t_data_nents, i) {
-		pr_err("[%d] off %d len %d\n",
-		       i, sg->offset, sg->length);
+		target_err("[%d] off %d len %d\n", i, sg->offset, sg->length);
 	}
 	return -1;
 }
@@ -1018,8 +1015,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_WRITE) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
-		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
-				" not set. Bad iSCSI Initiator.\n");
+		target_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
+			   " not set. Bad iSCSI Initiator.\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
@@ -1039,70 +1036,72 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		hdr->flags &= ~ISCSI_FLAG_CMD_READ;
 		hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
 
-		pr_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
-			" set when Expected Data Transfer Length is 0 for"
-			" CDB: 0x%02x, Fixing up flags\n", hdr->cdb[0]);
+		target_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+			    " set when Expected Data Transfer Length is 0 for"
+			    " CDB: 0x%02x, Fixing up flags\n",
+			    hdr->cdb[0]);
 	}
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
-		pr_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
-			" MUST be set if Expected Data Transfer Length is not 0."
-			" Bad iSCSI Initiator\n");
+		target_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
+			   " MUST be set if Expected Data Transfer Length is not 0."
+			   " Bad iSCSI Initiator\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
 	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
-		pr_err("Bidirectional operations not supported!\n");
+		target_err("Bidirectional operations not supported!\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
 	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
-		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
-				" Scsi Command PDU.\n");
+		target_err("Illegally set Immediate Bit in iSCSI Initiator"
+			   " Scsi Command PDU.\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
 	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
-		pr_err("ImmediateData=No but DataSegmentLength=%u,"
-			" protocol error.\n", payload_length);
+		target_err("ImmediateData=No but DataSegmentLength=%u,"
+			   " protocol error.\n",
+			   payload_length);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if ((be32_to_cpu(hdr->data_length) == payload_length) &&
 	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
-		pr_err("Expected Data Transfer Length and Length of"
-			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
-			" bit is not set protocol error\n");
+		target_err("Expected Data Transfer Length and Length of"
+			   " Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
+			   " bit is not set protocol error\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > be32_to_cpu(hdr->data_length)) {
-		pr_err("DataSegmentLength: %u is greater than"
-			" EDTL: %u, protocol error.\n", payload_length,
-				hdr->data_length);
+		target_err("DataSegmentLength: %u is greater than"
+			   " EDTL: %u, protocol error.\n",
+			   payload_length, hdr->data_length);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		pr_err("DataSegmentLength: %u is greater than"
-			" MaxXmitDataSegmentLength: %u, protocol error.\n",
-			payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
+		target_err("DataSegmentLength: %u is greater than"
+			   " MaxXmitDataSegmentLength: %u, protocol error.\n",
+			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
-		pr_err("DataSegmentLength: %u is greater than"
-			" FirstBurstLength: %u, protocol error.\n",
-			payload_length, conn->sess->sess_ops->FirstBurstLength);
+		target_err("DataSegmentLength: %u is greater than"
+			   " FirstBurstLength: %u, protocol error.\n",
+			   payload_length, conn->sess->sess_ops->FirstBurstLength);
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
@@ -1112,8 +1111,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (hdr->hlength) {
 		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
 		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
-			pr_err("Additional Header Segment type %d not supported!\n",
-			       ecdb_ahdr->ahstype);
+			target_err("Additional Header Segment type %d not supported!\n",
+				   ecdb_ahdr->ahstype);
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
 		}
@@ -1147,8 +1146,9 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	else if (iscsi_task_attr == ISCSI_ATTR_ACA)
 		sam_task_attr = TCM_ACA_TAG;
 	else {
-		pr_debug("Unknown iSCSI Task Attribute: 0x%02x, using"
-			" TCM_SIMPLE_TAG\n", iscsi_task_attr);
+		target_debug("Unknown iSCSI Task Attribute: 0x%02x, using"
+			     " TCM_SIMPLE_TAG\n",
+			     iscsi_task_attr);
 		sam_task_attr = TCM_SIMPLE_TAG;
 	}
 
@@ -1194,10 +1194,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
 			  conn->cmd_cnt);
 
-	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
-		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
-		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
-		conn->cid);
+	target_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
+		     " ExpXferLen: %u, Length: %u, CID: %hu\n",
+		     hdr->itt, hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
+		     conn->cid);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
@@ -1321,11 +1321,11 @@ iscsit_get_immediate_data(struct iscsit_cmd *cmd, struct iscsi_scsi_req *hdr,
 		u32 length = min(cmd->se_cmd.data_length - cmd->write_data_done,
 				 cmd->first_burst_len);
 
-		pr_debug("Dumping min(%d - %d, %d) = %d bytes of immediate data\n",
-			 cmd->se_cmd.data_length, cmd->write_data_done,
-			 cmd->first_burst_len, length);
+		target_debug("Dumping min(%d - %d, %d) = %d bytes of immediate data\n",
+			     cmd->se_cmd.data_length, cmd->write_data_done, cmd->first_burst_len,
+			     length);
 		rc = iscsit_dump_data_payload(cmd->conn, length, 1);
-		pr_debug("Finished dumping immediate data\n");
+		target_debug("Finished dumping immediate data\n");
 		if (rc < 0)
 			immed_ret = IMMEDIATE_DATA_CANNOT_RECOVER;
 	} else {
@@ -1489,30 +1489,30 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 	/* iSCSI write */
 	atomic_long_add(payload_length, &conn->sess->rx_data_octets);
 
-	pr_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
-		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
-		hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset),
-		payload_length, conn->cid);
+	target_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
+		     " DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		     hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset), payload_length,
+		     conn->cid);
 
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
-		pr_err("Command ITT: 0x%08x received DataOUT after"
-			" last DataOUT received, dumping payload\n",
-			cmd->init_task_tag);
+		target_err("Command ITT: 0x%08x received DataOUT after"
+			   " last DataOUT received, dumping payload\n",
+			   cmd->init_task_tag);
 		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 
 	if (cmd->data_direction != DMA_TO_DEVICE) {
-		pr_err("Command ITT: 0x%08x received DataOUT for a"
-			" NON-WRITE command.\n", cmd->init_task_tag);
+		target_err("Command ITT: 0x%08x received DataOUT for a"
+			   " NON-WRITE command.\n",
+			   cmd->init_task_tag);
 		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);
 
 	if ((be32_to_cpu(hdr->offset) + payload_length) > cmd->se_cmd.data_length) {
-		pr_err("DataOut Offset: %u, Length %u greater than iSCSI Command EDTL %u, protocol error.\n",
-		       be32_to_cpu(hdr->offset), payload_length,
-		       cmd->se_cmd.data_length);
+		target_err("DataOut Offset: %u, Length %u greater than iSCSI Command EDTL %u, protocol error.\n",
+			   be32_to_cpu(hdr->offset), payload_length, cmd->se_cmd.data_length);
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
@@ -1520,8 +1520,8 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 		int dump_unsolicited_data = 0;
 
 		if (conn->sess->sess_ops->InitialR2T) {
-			pr_err("Received unexpected unsolicited data"
-				" while InitialR2T=Yes, protocol error.\n");
+			target_err("Received unexpected unsolicited data"
+				   " while InitialR2T=Yes, protocol error.\n");
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
 			return -1;
@@ -1592,14 +1592,14 @@ iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 	bool success = false;
 
 	if (!payload_length) {
-		pr_warn_ratelimited("DataOUT payload is ZERO, ignoring.\n");
+		target_warn_ratelimited("DataOUT payload is ZERO, ignoring.\n");
 		return 0;
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		pr_err_ratelimited("DataSegmentLength: %u is greater than"
-			" MaxXmitDataSegmentLength: %u\n", payload_length,
-			conn->conn_ops->MaxXmitDataSegmentLength);
+		target_err_ratelimited("DataSegmentLength: %u is greater than"
+				       " MaxXmitDataSegmentLength: %u\n",
+				       payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
@@ -1642,7 +1642,7 @@ iscsit_get_dataout(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		iov[iov_count].iov_base	= cmd->pad_bytes;
 		iov[iov_count++].iov_len = padding;
 		rx_size += padding;
-		pr_debug("Receiving %u padding bytes.\n", padding);
+		target_debug("Receiving %u padding bytes.\n", padding);
 	}
 
 	if (conn->conn_ops->DataDigest) {
@@ -1668,16 +1668,16 @@ iscsit_get_dataout(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
-				" DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
-				" does not match computed 0x%08x\n",
-				hdr->itt, hdr->offset, payload_length,
-				hdr->datasn, checksum, data_crc);
+			target_err("ITT: 0x%08x, Offset: %u, Length: %u,"
+				   " DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
+				   " does not match computed 0x%08x\n",
+				   hdr->itt, hdr->offset, payload_length, hdr->datasn, checksum,
+				   data_crc);
 			data_crc_failed = 1;
 		} else {
-			pr_debug("Got CRC32C DataDigest 0x%08x for"
-				" %u bytes of Data Out\n", checksum,
-				payload_length);
+			target_debug("Got CRC32C DataDigest 0x%08x for"
+				     " %u bytes of Data Out\n",
+				     checksum, payload_length);
 		}
 	}
 
@@ -1751,7 +1751,7 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
-		pr_err("NopOUT Flag's, Left Most Bit not set, protocol error.\n");
+		target_err("NopOUT Flag's, Left Most Bit not set, protocol error.\n");
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
@@ -1761,8 +1761,8 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	}
 
 	if (hdr->itt == RESERVED_ITT && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		pr_err("NOPOUT ITT is reserved, but Immediate Bit is"
-			" not set, protocol error.\n");
+		target_err("NOPOUT ITT is reserved, but Immediate Bit is"
+			   " not set, protocol error.\n");
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
@@ -1772,10 +1772,10 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	}
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		pr_err("NOPOUT Ping Data DataSegmentLength: %u is"
-			" greater than MaxXmitDataSegmentLength: %u, protocol"
-			" error.\n", payload_length,
-			conn->conn_ops->MaxXmitDataSegmentLength);
+		target_err("NOPOUT Ping Data DataSegmentLength: %u is"
+			   " greater than MaxXmitDataSegmentLength: %u, protocol"
+			   " error.\n",
+			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		if (!cmd)
 			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 						 (unsigned char *)hdr);
@@ -1784,11 +1784,10 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					 (unsigned char *)hdr);
 	}
 
-	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
-		hdr->itt == RESERVED_ITT ? "Response" : "Request",
-		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
-		payload_length);
+	target_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x,"
+		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
+		     hdr->itt == RESERVED_ITT ? "Response" : "Request", hdr->itt, hdr->ttt,
+		     hdr->cmdsn, hdr->exp_statsn, payload_length);
 	/*
 	 * This is not a response to a Unsolicited NopIN, which means
 	 * it can either be a NOPOUT ping request (with a valid ITT),
@@ -1905,8 +1904,9 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 
 		padding = ((-payload_length) & 3);
 		if (padding != 0) {
-			pr_debug("Receiving %u additional bytes"
-				" for padding.\n", padding);
+			target_debug("Receiving %u additional bytes"
+				     " for padding.\n",
+				     padding);
 			iov[niov].iov_base	= &cmd->pad_bytes;
 			iov[niov++].iov_len	= padding;
 			rx_size += padding;
@@ -1930,13 +1930,13 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 						  cmd->pad_bytes, &data_crc);
 
 			if (checksum != data_crc) {
-				pr_err("Ping data CRC32C DataDigest"
-				" 0x%08x does not match computed 0x%08x\n",
-					checksum, data_crc);
+				target_err("Ping data CRC32C DataDigest"
+					   " 0x%08x does not match computed 0x%08x\n",
+					   checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					pr_err("Unable to recover from"
-					" NOPOUT Ping DataCRC failure while in"
-						" ERL=0.\n");
+					target_err("Unable to recover from"
+						   " NOPOUT Ping DataCRC failure while in"
+						   " ERL=0.\n");
 					ret = -1;
 					goto out;
 				} else {
@@ -1944,16 +1944,17 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					pr_debug("Dropping NOPOUT"
-					" Command CmdSN: 0x%08x due to"
-					" DataCRC error.\n", hdr->cmdsn);
+					target_debug("Dropping NOPOUT"
+						     " Command CmdSN: 0x%08x due to"
+						     " DataCRC error.\n",
+						     hdr->cmdsn);
 					ret = 0;
 					goto out;
 				}
 			} else {
-				pr_debug("Got CRC32C DataDigest"
-				" 0x%08x for %u bytes of ping data.\n",
-					checksum, payload_length);
+				target_debug("Got CRC32C DataDigest"
+					     " 0x%08x for %u bytes of ping data.\n",
+					     checksum, payload_length);
 			}
 		}
 
@@ -1964,9 +1965,10 @@ static int iscsit_handle_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cm
 		cmd->buf_ptr = ping_data;
 		cmd->buf_ptr_size = payload_length;
 
-		pr_debug("Got %u bytes of NOPOUT ping"
-			" data.\n", payload_length);
-		pr_debug("Ping Data: \"%s\"\n", ping_data);
+		target_debug("Got %u bytes of NOPOUT ping"
+			     " data.\n",
+			     payload_length);
+		target_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
 	return iscsit_process_nop_out(conn, cmd, hdr);
@@ -2014,23 +2016,23 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
 	function = hdr->flags;
 
-	pr_debug("Got Task Management Request ITT: 0x%08x, CmdSN:"
-		" 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
-		" 0x%08x, CID: %hu\n", hdr->itt, hdr->cmdsn, function,
-		hdr->rtt, hdr->refcmdsn, conn->cid);
+	target_debug("Got Task Management Request ITT: 0x%08x, CmdSN:"
+		     " 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
+		     " 0x%08x, CID: %hu\n",
+		     hdr->itt, hdr->cmdsn, function, hdr->rtt, hdr->refcmdsn, conn->cid);
 
 	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
 	    ((function != ISCSI_TM_FUNC_TASK_REASSIGN) &&
 	     hdr->rtt != RESERVED_ITT)) {
-		pr_err("RefTaskTag should be set to 0xFFFFFFFF.\n");
+		target_err("RefTaskTag should be set to 0xFFFFFFFF.\n");
 		hdr->rtt = RESERVED_ITT;
 	}
 
 	if ((function == ISCSI_TM_FUNC_TASK_REASSIGN) &&
 			!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-		pr_err("Task Management Request TASK_REASSIGN not"
-			" issued as immediate command, bad iSCSI Initiator"
-				"implementation\n");
+		target_err("Task Management Request TASK_REASSIGN not"
+			   " issued as immediate command, bad iSCSI Initiator"
+			   "implementation\n");
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
@@ -2061,8 +2063,9 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
 		tcm_function = iscsit_convert_tmf(function);
 		if (tcm_function == TMR_UNKNOWN) {
-			pr_err("Unknown iSCSI TMR Function:"
-			       " 0x%02x\n", function);
+			target_err("Unknown iSCSI TMR Function:"
+				   " 0x%02x\n",
+				   function);
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		}
@@ -2132,8 +2135,9 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					ISCSI_REASON_BOOKMARK_INVALID, buf);
 		break;
 	default:
-		pr_err("Unknown TMR function: 0x%02x, protocol"
-			" error.\n", function);
+		target_err("Unknown TMR function: 0x%02x, protocol"
+			   " error.\n",
+			   function);
 		se_tmr->response = ISCSI_TMF_RSP_NOT_SUPPORTED;
 		goto attach;
 	}
@@ -2189,23 +2193,23 @@ iscsit_setup_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
-		pr_err("Unable to accept text parameter length: %u"
-			"greater than MaxXmitDataSegmentLength %u.\n",
-		       payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
+		target_err("Unable to accept text parameter length: %u"
+			   "greater than MaxXmitDataSegmentLength %u.\n",
+			   payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
 	}
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL) ||
 	     (hdr->flags & ISCSI_FLAG_TEXT_CONTINUE)) {
-		pr_err("Multi sequence text commands currently not supported\n");
+		target_err("Multi sequence text commands currently not supported\n");
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_CMD_NOT_SUPPORTED,
 					(unsigned char *)hdr);
 	}
 
-	pr_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
-		" ExpStatSN: 0x%08x, Length: %u\n", hdr->itt, hdr->cmdsn,
-		hdr->exp_statsn, payload_length);
+	target_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
+		     " ExpStatSN: 0x%08x, Length: %u\n",
+		     hdr->itt, hdr->cmdsn, hdr->exp_statsn, payload_length);
 
 	cmd->iscsi_opcode	= ISCSI_OP_TEXT;
 	cmd->i_state		= ISTATE_SEND_TEXTRSP;
@@ -2232,15 +2236,15 @@ iscsit_process_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	if (!text_in) {
 		cmd->targ_xfer_tag = be32_to_cpu(hdr->ttt);
 		if (cmd->targ_xfer_tag == 0xFFFFFFFF) {
-			pr_err("Unable to locate text_in buffer for sendtargets"
-			       " discovery\n");
+			target_err("Unable to locate text_in buffer for sendtargets"
+				   " discovery\n");
 			goto reject;
 		}
 		goto empty_sendtargets;
 	}
 	if (strncmp("SendTargets=", text_in, 12) != 0) {
-		pr_err("Received Text Data that is not"
-			" SendTargets, cannot continue.\n");
+		target_err("Received Text Data that is not"
+			   " SendTargets, cannot continue.\n");
 		goto reject;
 	}
 	/* '=' confirmed in strncmp */
@@ -2252,8 +2256,7 @@ iscsit_process_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		   !strncmp("=eui.", text_ptr, 5)) {
 		cmd->cmd_flags |= ICF_SENDTARGETS_SINGLE;
 	} else {
-		pr_err("Unable to locate valid SendTargets%s value\n",
-		       text_ptr);
+		target_err("Unable to locate valid SendTargets%s value\n", text_ptr);
 		goto reject;
 	}
 
@@ -2314,8 +2317,9 @@ iscsit_handle_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 
 		padding = rx_size - payload_length;
 		if (padding)
-			pr_debug("Receiving %u additional bytes"
-					" for padding.\n", padding);
+			target_debug("Receiving %u additional bytes"
+				     " for padding.\n",
+				     padding);
 		if (conn->conn_ops->DataDigest) {
 			iov[niov].iov_base	= &checksum;
 			iov[niov++].iov_len	= ISCSI_CRC_LEN;
@@ -2333,34 +2337,37 @@ iscsit_handle_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 						  &data_crc);
 
 			if (checksum != data_crc) {
-				pr_err("Text data CRC32C DataDigest"
-					" 0x%08x does not match computed"
-					" 0x%08x\n", checksum, data_crc);
+				target_err("Text data CRC32C DataDigest"
+					   " 0x%08x does not match computed"
+					   " 0x%08x\n",
+					   checksum, data_crc);
 				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-					pr_err("Unable to recover from"
-					" Text Data digest failure while in"
-						" ERL=0.\n");
+					target_err("Unable to recover from"
+						   " Text Data digest failure while in"
+						   " ERL=0.\n");
 					goto reject;
 				} else {
 					/*
 					 * Silently drop this PDU and let the
 					 * initiator plug the CmdSN gap.
 					 */
-					pr_debug("Dropping Text"
-					" Command CmdSN: 0x%08x due to"
-					" DataCRC error.\n", hdr->cmdsn);
+					target_debug("Dropping Text"
+						     " Command CmdSN: 0x%08x due to"
+						     " DataCRC error.\n",
+						     hdr->cmdsn);
 					kfree(text_in);
 					return 0;
 				}
 			} else {
-				pr_debug("Got CRC32C DataDigest"
-					" 0x%08x for %u bytes of text data.\n",
-						checksum, payload_length);
+				target_debug("Got CRC32C DataDigest"
+					     " 0x%08x for %u bytes of text data.\n",
+					     checksum, payload_length);
 			}
 		}
 		text_in[payload_length - 1] = '\0';
-		pr_debug("Successfully read %d bytes of text"
-				" data.\n", payload_length);
+		target_debug("Successfully read %d bytes of text"
+			     " data.\n",
+			     payload_length);
 	}
 
 	return iscsit_process_text_cmd(conn, cmd, hdr);
@@ -2376,8 +2383,9 @@ int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	struct iscsit_conn *conn_p;
 	struct iscsit_session *sess = conn->sess;
 
-	pr_debug("Received logout request CLOSESESSION on CID: %hu"
-		" for SID: %u.\n", conn->cid, conn->sess->sid);
+	target_debug("Received logout request CLOSESESSION on CID: %hu"
+		     " for SID: %u.\n",
+		     conn->cid, conn->sess->sid);
 
 	atomic_set(&sess->session_logout, 1);
 	atomic_set(&conn->conn_logout_remove, 1);
@@ -2391,7 +2399,7 @@ int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 		if (conn_p->conn_state != TARG_CONN_STATE_LOGGED_IN)
 			continue;
 
-		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		target_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn_p->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -2406,8 +2414,9 @@ int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *co
 	struct iscsit_conn *l_conn;
 	struct iscsit_session *sess = conn->sess;
 
-	pr_debug("Received logout request CLOSECONNECTION for CID:"
-		" %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+	target_debug("Received logout request CLOSECONNECTION for CID:"
+		     " %hu on CID: %hu.\n",
+		     cmd->logout_cid, conn->cid);
 
 	/*
 	 * A Logout Request with a CLOSECONNECTION reason code for a CID
@@ -2415,7 +2424,7 @@ int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *co
 	 */
 	if (conn->cid == cmd->logout_cid) {
 		spin_lock_bh(&conn->state_lock);
-		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		target_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 		conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 
 		atomic_set(&conn->conn_logout_remove, 1);
@@ -2453,21 +2462,22 @@ int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *cmd, struct iscsit_co
 {
 	struct iscsit_session *sess = conn->sess;
 
-	pr_debug("Received explicit REMOVECONNFORRECOVERY logout for"
-		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+	target_debug("Received explicit REMOVECONNFORRECOVERY logout for"
+		     " CID: %hu on CID: %hu.\n",
+		     cmd->logout_cid, conn->cid);
 
 	if (sess->sess_ops->ErrorRecoveryLevel != 2) {
-		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
-			" while ERL!=2.\n");
+		target_err("Received Logout Request REMOVECONNFORRECOVERY"
+			   " while ERL!=2.\n");
 		cmd->logout_response = ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 		return 0;
 	}
 
 	if (conn->cid == cmd->logout_cid) {
-		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
-			" with CID: %hu on CID: %hu, implementation error.\n",
-				cmd->logout_cid, conn->cid);
+		target_err("Received Logout Request REMOVECONNFORRECOVERY"
+			   " with CID: %hu on CID: %hu, implementation error.\n",
+			   cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_CLEANUP_FAILED;
 		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
 		return 0;
@@ -2499,14 +2509,13 @@ iscsit_handle_logout_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 		spin_unlock(&tiqn->logout_stats.lock);
 	}
 
-	pr_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
-		" ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
-		hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code,
-		hdr->cid, conn->cid);
+	target_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
+		     " ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
+		     hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code, hdr->cid, conn->cid);
 
 	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
-		pr_err("Received logout request on connection that"
-			" is not in logged in state, ignoring request.\n");
+		target_err("Received logout request on connection that"
+			   " is not in logged in state, ignoring request.\n");
 		iscsit_free_cmd(cmd, false);
 		return 0;
 	}
@@ -2568,14 +2577,14 @@ int iscsit_handle_snack(
 	hdr			= (struct iscsi_snack *) buf;
 	hdr->flags		&= ~ISCSI_FLAG_CMD_FINAL;
 
-	pr_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
-		" 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
-		" CID: %hu\n", hdr->itt, hdr->exp_statsn, hdr->flags,
-			hdr->begrun, hdr->runlength, conn->cid);
+	target_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
+		     " 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
+		     " CID: %hu\n",
+		     hdr->itt, hdr->exp_statsn, hdr->flags, hdr->begrun, hdr->runlength, conn->cid);
 
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		pr_err("Initiator sent SNACK request while in"
-			" ErrorRecoveryLevel=0.\n");
+		target_err("Initiator sent SNACK request while in"
+			   " ErrorRecoveryLevel=0.\n");
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	}
@@ -2600,12 +2609,13 @@ int iscsit_handle_snack(
 			be32_to_cpu(hdr->runlength));
 	case ISCSI_FLAG_SNACK_TYPE_RDATA:
 		/* FIXME: Support R-Data SNACK */
-		pr_err("R-Data SNACK Not Supported.\n");
+		target_err("R-Data SNACK Not Supported.\n");
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	default:
-		pr_err("Unknown SNACK type 0x%02x, protocol"
-			" error.\n", hdr->flags & 0x0f);
+		target_err("Unknown SNACK type 0x%02x, protocol"
+			   " error.\n",
+			   hdr->flags & 0x0f);
 		return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					 buf);
 	}
@@ -2693,14 +2703,14 @@ static int iscsit_handle_immediate_data(
 						    cmd->pad_bytes);
 
 		if (checksum != data_crc) {
-			pr_err("ImmediateData CRC32C DataDigest 0x%08x"
-				" does not match computed 0x%08x\n", checksum,
-				data_crc);
+			target_err("ImmediateData CRC32C DataDigest 0x%08x"
+				   " does not match computed 0x%08x\n",
+				   checksum, data_crc);
 
 			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-				pr_err("Unable to recover from"
-					" Immediate Data digest failure while"
-					" in ERL=0.\n");
+				target_err("Unable to recover from"
+					   " Immediate Data digest failure while"
+					   " in ERL=0.\n");
 				iscsit_reject_cmd(cmd,
 						ISCSI_REASON_DATA_DIGEST_ERROR,
 						(unsigned char *)hdr);
@@ -2712,9 +2722,9 @@ static int iscsit_handle_immediate_data(
 				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
 			}
 		} else {
-			pr_debug("Got CRC32C DataDigest 0x%08x for"
-				" %u bytes of Immediate Data\n", checksum,
-				length);
+			target_debug("Got CRC32C DataDigest 0x%08x for"
+				     " %u bytes of Immediate Data\n",
+				     checksum, length);
 		}
 	}
 
@@ -2796,9 +2806,9 @@ static int iscsit_send_conn_drop_async_message(
 	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
 	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
 
-	pr_debug("Sending Connection Dropped Async Message StatSN:"
-		" 0x%08x, for CID: %hu on CID: %hu\n", cmd->stat_sn,
-			cmd->logout_cid, conn->cid);
+	target_debug("Sending Connection Dropped Async Message StatSN:"
+		     " 0x%08x, for CID: %hu on CID: %hu\n",
+		     cmd->stat_sn, cmd->logout_cid, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
 }
@@ -2852,10 +2862,10 @@ iscsit_build_datain_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->datasn		= cpu_to_be32(datain->data_sn);
 	hdr->offset		= cpu_to_be32(datain->offset);
 
-	pr_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
-		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
-		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
-		ntohl(hdr->offset), datain->length, conn->cid);
+	target_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
+		     " DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		     cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn), ntohl(hdr->offset),
+		     datain->length, conn->cid);
 }
 EXPORT_SYMBOL(iscsit_build_datain_pdu);
 
@@ -2870,18 +2880,17 @@ static int iscsit_send_datain(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	memset(&datain, 0, sizeof(struct iscsi_datain));
 	dr = iscsit_get_datain_values(cmd, &datain);
 	if (!dr) {
-		pr_err("iscsit_get_datain_values failed for ITT: 0x%08x\n",
-				cmd->init_task_tag);
+		target_err("iscsit_get_datain_values failed for ITT: 0x%08x\n", cmd->init_task_tag);
 		return -1;
 	}
 	/*
 	 * Be paranoid and double check the logic for now.
 	 */
 	if ((datain.offset + datain.length) > cmd->se_cmd.data_length) {
-		pr_err("Command ITT: 0x%08x, datain.offset: %u and"
-			" datain.length: %u exceeds cmd->data_length: %u\n",
-			cmd->init_task_tag, datain.offset, datain.length,
-			cmd->se_cmd.data_length);
+		target_err("Command ITT: 0x%08x, datain.offset: %u and"
+			   " datain.length: %u exceeds cmd->data_length: %u\n",
+			   cmd->init_task_tag, datain.offset, datain.length,
+			   cmd->se_cmd.data_length);
 		return -1;
 	}
 
@@ -2933,8 +2942,8 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	 */
 	switch (cmd->logout_reason) {
 	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
-		pr_debug("iSCSI session logout successful, setting"
-			" logout response to ISCSI_LOGOUT_SUCCESS.\n");
+		target_debug("iSCSI session logout successful, setting"
+			     " logout response to ISCSI_LOGOUT_SUCCESS.\n");
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
@@ -2952,8 +2961,9 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		 * is stopped in iscsit_logout_post_handler_diffcid().
 		 */
 
-		pr_debug("iSCSI CID: %hu logout on CID: %hu"
-			" successful.\n", cmd->logout_cid, conn->cid);
+		target_debug("iSCSI CID: %hu logout on CID: %hu"
+			     " successful.\n",
+			     cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	case ISCSI_LOGOUT_REASON_RECOVERY:
@@ -2974,23 +2984,22 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				conn->sess, cmd->logout_cid);
 		if (!cr) {
-			pr_err("Unable to locate CID: %hu for"
-			" REMOVECONNFORRECOVERY Logout Request.\n",
-				cmd->logout_cid);
+			target_err("Unable to locate CID: %hu for"
+				   " REMOVECONNFORRECOVERY Logout Request.\n",
+				   cmd->logout_cid);
 			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
 			break;
 		}
 
 		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
 
-		pr_debug("iSCSI REMOVECONNFORRECOVERY logout"
-			" for recovery for CID: %hu on CID: %hu successful.\n",
-				cmd->logout_cid, conn->cid);
+		target_debug("iSCSI REMOVECONNFORRECOVERY logout"
+			     " for recovery for CID: %hu on CID: %hu successful.\n",
+			     cmd->logout_cid, conn->cid);
 		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
 		break;
 	default:
-		pr_err("Unknown cmd->logout_reason: 0x%02x\n",
-				cmd->logout_reason);
+		target_err("Unknown cmd->logout_reason: 0x%02x\n", cmd->logout_reason);
 		return -1;
 	}
 
@@ -3005,10 +3014,9 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Built Logout Response ITT: 0x%08x StatSN:"
-		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
-		cmd->init_task_tag, cmd->stat_sn, hdr->response,
-		cmd->logout_cid, conn->cid);
+	target_debug("Built Logout Response ITT: 0x%08x StatSN:"
+		     " 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+		     cmd->init_task_tag, cmd->stat_sn, hdr->response, cmd->logout_cid, conn->cid);
 
 	return 0;
 }
@@ -3048,10 +3056,10 @@ iscsit_build_nopin_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
-		" StatSN: 0x%08x, Length %u\n", (nopout_response) ?
-		"Solicited" : "Unsolicited", cmd->init_task_tag,
-		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
+	target_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
+		     " StatSN: 0x%08x, Length %u\n",
+		     (nopout_response) ? "Solicited" : "Unsolicited", cmd->init_task_tag,
+		     cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
 }
 EXPORT_SYMBOL(iscsit_build_nopin_rsp);
 
@@ -3068,8 +3076,9 @@ static int iscsit_send_unsolicited_nopin(
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
-	pr_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
-		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
+	target_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
+		     " 0x%08x CID: %hu\n",
+		     hdr->ttt, cmd->stat_sn, conn->cid);
 
 	ret = conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
 	if (ret < 0)
@@ -3094,7 +3103,7 @@ iscsit_send_nopin(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 	 * NOPOUT Ping Data is attached to struct iscsit_cmd->buf_ptr.
 	 * NOPOUT DataSegmentLength is at struct iscsit_cmd->buf_ptr_size.
 	 */
-	pr_debug("Echoing back %u bytes of ping data.\n", cmd->buf_ptr_size);
+	target_debug("Echoing back %u bytes of ping data.\n", cmd->buf_ptr_size);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL,
 						     cmd->buf_ptr,
@@ -3132,11 +3141,11 @@ static int iscsit_send_r2t(
 	hdr->data_offset	= cpu_to_be32(r2t->offset);
 	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
 
-	pr_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
-		" 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
-		(!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
-		r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn,
-			r2t->offset, r2t->xfer_len, conn->cid);
+	target_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
+		     " 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
+		     (!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
+		     r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn, r2t->offset,
+		     r2t->xfer_len, conn->cid);
 
 	spin_lock_bh(&cmd->r2t_lock);
 	r2t->sent_r2t = 1;
@@ -3269,10 +3278,10 @@ void iscsit_build_rsp_pdu(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
-		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
-		cmd->init_task_tag, cmd->stat_sn, cmd->se_cmd.scsi_status,
-		cmd->se_cmd.scsi_status, conn->cid);
+	target_debug("Built SCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
+		     " Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+		     cmd->init_task_tag, cmd->stat_sn, cmd->se_cmd.scsi_status,
+		     cmd->se_cmd.scsi_status, conn->cid);
 }
 EXPORT_SYMBOL(iscsit_build_rsp_pdu);
 
@@ -3302,13 +3311,14 @@ static int iscsit_send_response(struct iscsit_cmd *cmd, struct iscsit_conn *conn
 		if (padding) {
 			memset(cmd->sense_buffer +
 				cmd->se_cmd.scsi_sense_length, 0, padding);
-			pr_debug("Adding %u bytes of padding to"
-				" SENSE.\n", padding);
+			target_debug("Adding %u bytes of padding to"
+				     " SENSE.\n",
+				     padding);
 		}
 
-		pr_debug("Attaching SENSE DATA: %u bytes to iSCSI"
-				" Response PDU\n",
-				cmd->se_cmd.scsi_sense_length);
+		target_debug("Attaching SENSE DATA: %u bytes to iSCSI"
+			     " Response PDU\n",
+			     cmd->se_cmd.scsi_sense_length);
 	}
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, data_buf,
@@ -3349,9 +3359,9 @@ iscsit_build_task_mgt_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Built Task Management Response ITT: 0x%08x,"
-		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
-		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
+	target_debug("Built Task Management Response ITT: 0x%08x,"
+		     " StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+		     cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
 }
 EXPORT_SYMBOL(iscsit_build_task_mgt_rsp);
 
@@ -3397,8 +3407,9 @@ iscsit_build_sendtargets_response(struct iscsit_cmd *cmd,
 	if (cmd->cmd_flags & ICF_SENDTARGETS_SINGLE) {
 		text_ptr = strchr(text_in, '=');
 		if (!text_ptr) {
-			pr_err("Unable to locate '=' string in text_in:"
-			       " %s\n", text_in);
+			target_err("Unable to locate '=' string in text_in:"
+				   " %s\n",
+				   text_in);
 			kfree(payload);
 			return -EINVAL;
 		}
@@ -3557,11 +3568,11 @@ iscsit_build_text_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 	hdr->exp_cmdsn = cpu_to_be32(conn->sess->exp_cmd_sn);
 	hdr->max_cmdsn = cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x,"
-		" Length: %u, CID: %hu F: %d C: %d\n", cmd->init_task_tag,
-		cmd->targ_xfer_tag, cmd->stat_sn, text_length, conn->cid,
-		!!(hdr->flags & ISCSI_FLAG_CMD_FINAL),
-		!!(hdr->flags & ISCSI_FLAG_TEXT_CONTINUE));
+	target_debug("Built Text Response: ITT: 0x%08x, TTT: 0x%08x, StatSN: 0x%08x,"
+		     " Length: %u, CID: %hu F: %d C: %d\n",
+		     cmd->init_task_tag, cmd->targ_xfer_tag, cmd->stat_sn, text_length, conn->cid,
+		     !!(hdr->flags & ISCSI_FLAG_CMD_FINAL),
+		     !!(hdr->flags & ISCSI_FLAG_TEXT_CONTINUE));
 
 	return text_length + padding;
 }
@@ -3609,8 +3620,9 @@ static int iscsit_send_reject(
 
 	iscsit_build_reject(cmd, conn, hdr);
 
-	pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
-		" CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
+	target_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
+		     " CID: %hu\n",
+		     ntohl(hdr->statsn), hdr->reason, conn->cid);
 
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL,
 						     cmd->buf_ptr,
@@ -3746,10 +3758,9 @@ iscsit_immediate_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int sta
 			goto err;
 		break;
 	default:
-		pr_err("Unknown Opcode: 0x%02x ITT:"
-		       " 0x%08x, i_state: %d on CID: %hu\n",
-		       cmd->iscsi_opcode, cmd->init_task_tag, state,
-		       conn->cid);
+		target_err("Unknown Opcode: 0x%02x ITT:"
+			   " 0x%08x, i_state: %d on CID: %hu\n",
+			   cmd->iscsi_opcode, cmd->init_task_tag, state, conn->cid);
 		goto err;
 	}
 
@@ -3847,10 +3858,9 @@ iscsit_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 		ret = iscsit_send_text_rsp(cmd, conn);
 		break;
 	default:
-		pr_err("Unknown Opcode: 0x%02x ITT:"
-		       " 0x%08x, i_state: %d on CID: %hu\n",
-		       cmd->iscsi_opcode, cmd->init_task_tag,
-		       state, conn->cid);
+		target_err("Unknown Opcode: 0x%02x ITT:"
+			   " 0x%08x, i_state: %d on CID: %hu\n",
+			   cmd->iscsi_opcode, cmd->init_task_tag, state, conn->cid);
 		goto err;
 	}
 	if (ret < 0)
@@ -3873,10 +3883,9 @@ iscsit_response_queue(struct iscsit_conn *conn, struct iscsit_cmd *cmd, int stat
 		spin_unlock_bh(&cmd->istate_lock);
 		break;
 	default:
-		pr_err("Unknown Opcode: 0x%02x ITT:"
-		       " 0x%08x, i_state: %d on CID: %hu\n",
-		       cmd->iscsi_opcode, cmd->init_task_tag,
-		       cmd->i_state, conn->cid);
+		target_err("Unknown Opcode: 0x%02x ITT:"
+			   " 0x%08x, i_state: %d on CID: %hu\n",
+			   cmd->iscsi_opcode, cmd->init_task_tag, cmd->i_state, conn->cid);
 		goto err;
 	}
 
@@ -4029,14 +4038,14 @@ static int iscsi_target_rx_opcode(struct iscsit_conn *conn, unsigned char *buf)
 		ret = iscsit_handle_snack(conn, buf);
 		break;
 	default:
-		pr_err("Got unknown iSCSI OpCode: 0x%02x\n", hdr->opcode);
+		target_err("Got unknown iSCSI OpCode: 0x%02x\n", hdr->opcode);
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Cannot recover from unknown"
-			" opcode while ERL=0, closing iSCSI connection.\n");
+			target_err("Cannot recover from unknown"
+				   " opcode while ERL=0, closing iSCSI connection.\n");
 			return -1;
 		}
-		pr_err("Unable to recover from unknown opcode while OFMarker=No,"
-		       " closing iSCSI connection.\n");
+		target_err("Unable to recover from unknown opcode while OFMarker=No,"
+			   " closing iSCSI connection.\n");
 		ret = -1;
 		break;
 	}
@@ -4121,9 +4130,9 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 						  &checksum);
 
 			if (digest != checksum) {
-				pr_err("HeaderDigest CRC32C failed,"
-					" received 0x%08x, computed 0x%08x\n",
-					digest, checksum);
+				target_err("HeaderDigest CRC32C failed,"
+					   " received 0x%08x, computed 0x%08x\n",
+					   digest, checksum);
 				/*
 				 * Set the PDU to 0xff so it will intentionally
 				 * hit default in the switch below.
@@ -4131,8 +4140,9 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 				memset(buffer, 0xff, ISCSI_HDR_LEN);
 				atomic_long_inc(&conn->sess->conn_digest_errors);
 			} else {
-				pr_debug("Got HeaderDigest CRC32C"
-						" 0x%08x\n", checksum);
+				target_debug("Got HeaderDigest CRC32C"
+					     " 0x%08x\n",
+					     checksum);
 			}
 		}
 
@@ -4144,8 +4154,9 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 		if (conn->sess->sess_ops->SessionType &&
 		   ((!(opcode & ISCSI_OP_TEXT)) ||
 		    (!(opcode & ISCSI_OP_LOGOUT)))) {
-			pr_err("Received illegal iSCSI Opcode: 0x%02x"
-			" while in Discovery Session, rejecting.\n", opcode);
+			target_err("Received illegal iSCSI Opcode: 0x%02x"
+				   " while in Discovery Session, rejecting.\n",
+				   opcode);
 			iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 					  buffer);
 			break;
@@ -4281,8 +4292,9 @@ int iscsit_close_connection(
 	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
 	struct iscsit_session	*sess = conn->sess;
 
-	pr_debug("Closing iSCSI connection CID %hu on SID:"
-		" %u\n", conn->cid, sess->sid);
+	target_debug("Closing iSCSI connection CID %hu on SID:"
+		     " %u\n",
+		     conn->cid, sess->sid);
 	/*
 	 * Always up conn_logout_comp for the traditional TCP and HW_OFFLOAD
 	 * case just in case the RX Thread in iscsi_target_rx_opcode() is
@@ -4421,15 +4433,15 @@ int iscsit_close_connection(
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
+	target_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 	iscsit_free_conn(conn);
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
-	pr_debug("Decremented iSCSI connection count to %d from node:"
-		" %s\n", atomic_read(&sess->nconn),
-		sess->sess_ops->InitiatorName);
+	target_debug("Decremented iSCSI connection count to %d from node:"
+		     " %s\n",
+		     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 	/*
 	 * Make sure that if one connection fails in an non ERL=2 iSCSI
 	 * Session that they all fail.
@@ -4481,7 +4493,7 @@ int iscsit_close_connection(
 
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
-		pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
+		target_debug("Moving to TARG_SESS_STATE_FREE.\n");
 		sess->session_state = TARG_SESS_STATE_FREE;
 
 		if (atomic_read(&sess->session_close)) {
@@ -4494,7 +4506,7 @@ int iscsit_close_connection(
 
 		return 0;
 	} else {
-		pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
+		target_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 		sess->session_state = TARG_SESS_STATE_FAILED;
 
 		if (!atomic_read(&sess->session_continuation))
@@ -4522,9 +4534,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	if (atomic_read(&sess->nconn)) {
-		pr_err("%d connection(s) still exist for iSCSI session"
-			" to %s\n", atomic_read(&sess->nconn),
-			sess->sess_ops->InitiatorName);
+		target_err("%d connection(s) still exist for iSCSI session"
+			   " to %s\n",
+			   atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 		BUG();
 	}
 
@@ -4563,16 +4575,16 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-	pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
+	target_debug("Moving to TARG_SESS_STATE_FREE.\n");
 	sess->session_state = TARG_SESS_STATE_FREE;
-	pr_debug("Released iSCSI session from node: %s\n",
-			sess->sess_ops->InitiatorName);
+	target_debug("Released iSCSI session from node: %s\n", sess->sess_ops->InitiatorName);
 	tpg->nsessions--;
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions--;
 
-	pr_debug("Decremented number of active iSCSI Sessions on"
-		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
+	target_debug("Decremented number of active iSCSI Sessions on"
+		     " iSCSI TPG: %hu to %u\n",
+		     tpg->tpgt, tpg->nsessions);
 
 	ida_free(&sess_ida, sess->session_index);
 	kfree(sess->sess_ops);
@@ -4658,7 +4670,7 @@ static void iscsit_logout_post_handler_diffcid(
 		l_conn->sock->ops->shutdown(l_conn->sock, RCV_SHUTDOWN);
 
 	spin_lock_bh(&l_conn->state_lock);
-	pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+	target_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
 	l_conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
 	spin_unlock_bh(&l_conn->state_lock);
 
@@ -4733,12 +4745,12 @@ void iscsit_fail_session(struct iscsit_session *sess)
 
 	spin_lock_bh(&sess->conn_lock);
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
-		pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+		target_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
 		conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
 	}
 	spin_unlock_bh(&sess->conn_lock);
 
-	pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
+	target_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 	sess->session_state = TARG_SESS_STATE_FAILED;
 }
 
@@ -4833,8 +4845,9 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 		session_count++;
 	}
 
-	pr_debug("Released %d iSCSI Session(s) from Target Portal"
-			" Group: %hu\n", session_count, tpg->tpgt);
+	target_debug("Released %d iSCSI Session(s) from Target Portal"
+		     " Group: %hu\n",
+		     session_count, tpg->tpgt);
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c8a248bd11be..694b2ec612cd 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -62,8 +62,8 @@ static int chap_gen_challenge(
 	*c_len += sprintf(c_str + *c_len, "CHAP_C=0x%s", challenge_asciihex);
 	*c_len += 1;
 
-	pr_debug("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
-			challenge_asciihex);
+	target_debug("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
+		     challenge_asciihex);
 
 out:
 	kfree(challenge_asciihex);
@@ -90,7 +90,7 @@ static int chap_check_algorithm(const char *a_str)
 
 	tmp = kstrdup(a_str, GFP_KERNEL);
 	if (!tmp) {
-		pr_err("Memory allocation failed for CHAP_A temporary buffer\n");
+		target_err("Memory allocation failed for CHAP_A temporary buffer\n");
 		return CHAP_DIGEST_UNKNOWN;
 	}
 	orig = tmp;
@@ -100,7 +100,7 @@ static int chap_check_algorithm(const char *a_str)
 		goto out;
 
 	if (strcmp(token, "CHAP_A")) {
-		pr_err("Unable to locate CHAP_A key\n");
+		target_err("Unable to locate CHAP_A key\n");
 		goto out;
 	}
 	while (token) {
@@ -115,9 +115,9 @@ static int chap_check_algorithm(const char *a_str)
 		if (!digest_name)
 			continue;
 
-		pr_debug("Selected %s Algorithm\n", digest_name);
+		target_debug("Selected %s Algorithm\n", digest_name);
 		if (chap_test_algorithm(digest_name) < 0) {
-			pr_err("failed to allocate %s algo\n", digest_name);
+			target_err("failed to allocate %s algo\n", digest_name);
 		} else {
 			r = digest_type;
 			goto out;
@@ -146,8 +146,8 @@ static struct iscsi_chap *chap_server_open(
 
 	if (!(auth->naf_flags & NAF_USERID_SET) ||
 	    !(auth->naf_flags & NAF_PASSWORD_SET)) {
-		pr_err("CHAP user or password not set for"
-				" Initiator ACL\n");
+		target_err("CHAP user or password not set for"
+			   " Initiator ACL\n");
 		return NULL;
 	}
 
@@ -172,7 +172,7 @@ static struct iscsi_chap *chap_server_open(
 		break;
 	case CHAP_DIGEST_UNKNOWN:
 	default:
-		pr_err("Unsupported CHAP_A value\n");
+		target_err("Unsupported CHAP_A value\n");
 		chap_close(conn);
 		return NULL;
 	}
@@ -182,10 +182,10 @@ static struct iscsi_chap *chap_server_open(
 	/* Tie the challenge length to the digest size */
 	chap->challenge_len = chap->digest_size;
 
-	pr_debug("[server] Got CHAP_A=%d\n", digest_type);
+	target_debug("[server] Got CHAP_A=%d\n", digest_type);
 	*aic_len = sprintf(aic_str, "CHAP_A=%d", digest_type);
 	*aic_len += 1;
-	pr_debug("[server] Sending CHAP_A=%d\n", digest_type);
+	target_debug("[server] Sending CHAP_A=%d\n", digest_type);
 
 	/*
 	 * Set Identifier.
@@ -193,7 +193,7 @@ static struct iscsi_chap *chap_server_open(
 	chap->id = conn->tpg->tpg_chap_id++;
 	*aic_len += sprintf(aic_str + *aic_len, "CHAP_I=%d", chap->id);
 	*aic_len += 1;
-	pr_debug("[server] Sending CHAP_I=%d\n", chap->id);
+	target_debug("[server] Sending CHAP_I=%d\n", chap->id);
 	/*
 	 * Generate Challenge.
 	 */
@@ -262,25 +262,25 @@ static int chap_server_compute_hash(
 
 	digest = kzalloc(chap->digest_size, GFP_KERNEL);
 	if (!digest) {
-		pr_err("Unable to allocate the digest buffer\n");
+		target_err("Unable to allocate the digest buffer\n");
 		goto out;
 	}
 
 	response = kzalloc(chap->digest_size * 2 + 2, GFP_KERNEL);
 	if (!response) {
-		pr_err("Unable to allocate the response buffer\n");
+		target_err("Unable to allocate the response buffer\n");
 		goto out;
 	}
 
 	client_digest = kzalloc(chap->digest_size, GFP_KERNEL);
 	if (!client_digest) {
-		pr_err("Unable to allocate the client_digest buffer\n");
+		target_err("Unable to allocate the client_digest buffer\n");
 		goto out;
 	}
 
 	server_digest = kzalloc(chap->digest_size, GFP_KERNEL);
 	if (!server_digest) {
-		pr_err("Unable to allocate the server_digest buffer\n");
+		target_err("Unable to allocate the server_digest buffer\n");
 		goto out;
 	}
 
@@ -290,13 +290,13 @@ static int chap_server_compute_hash(
 
 	initiatorchg = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!initiatorchg) {
-		pr_err("Unable to allocate challenge buffer\n");
+		target_err("Unable to allocate challenge buffer\n");
 		goto out;
 	}
 
 	initiatorchg_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!initiatorchg_binhex) {
-		pr_err("Unable to allocate initiatorchg_binhex buffer\n");
+		target_err("Unable to allocate initiatorchg_binhex buffer\n");
 		goto out;
 	}
 	/*
@@ -304,65 +304,65 @@ static int chap_server_compute_hash(
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
 				&type) < 0) {
-		pr_err("Could not find CHAP_N.\n");
+		target_err("Could not find CHAP_N.\n");
 		goto out;
 	}
 	if (type == HEX) {
-		pr_err("Could not find CHAP_N.\n");
+		target_err("Could not find CHAP_N.\n");
 		goto out;
 	}
 
 	/* Include the terminating NULL in the compare */
 	compare_len = strlen(auth->userid) + 1;
 	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
-		pr_err("CHAP_N values do not match!\n");
+		target_err("CHAP_N values do not match!\n");
 		goto out;
 	}
-	pr_debug("[server] Got CHAP_N=%s\n", chap_n);
+	target_debug("[server] Got CHAP_N=%s\n", chap_n);
 	/*
 	 * Extract CHAP_R.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_R", MAX_RESPONSE_LENGTH, chap_r,
 				&type) < 0) {
-		pr_err("Could not find CHAP_R.\n");
+		target_err("Could not find CHAP_R.\n");
 		goto out;
 	}
 
 	switch (type) {
 	case HEX:
 		if (strlen(chap_r) != chap->digest_size * 2) {
-			pr_err("Malformed CHAP_R\n");
+			target_err("Malformed CHAP_R\n");
 			goto out;
 		}
 		if (hex2bin(client_digest, chap_r, chap->digest_size) < 0) {
-			pr_err("Malformed CHAP_R: invalid HEX\n");
+			target_err("Malformed CHAP_R: invalid HEX\n");
 			goto out;
 		}
 		break;
 	case BASE64:
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
-			pr_err("Malformed CHAP_R: invalid BASE64\n");
+			target_err("Malformed CHAP_R: invalid BASE64\n");
 			goto out;
 		}
 		break;
 	default:
-		pr_err("Could not find CHAP_R\n");
+		target_err("Could not find CHAP_R\n");
 		goto out;
 	}
 
-	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
+	target_debug("[server] Got CHAP_R=%s\n", chap_r);
 
 	tfm = crypto_alloc_shash(chap->digest_name, 0, 0);
 	if (IS_ERR(tfm)) {
 		tfm = NULL;
-		pr_err("Unable to allocate struct crypto_shash\n");
+		target_err("Unable to allocate struct crypto_shash\n");
 		goto out;
 	}
 
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
 	if (!desc) {
-		pr_err("Unable to allocate struct shash_desc\n");
+		target_err("Unable to allocate struct shash_desc\n");
 		goto out;
 	}
 
@@ -370,41 +370,40 @@ static int chap_server_compute_hash(
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0) {
-		pr_err("crypto_shash_init() failed\n");
+		target_err("crypto_shash_init() failed\n");
 		goto out;
 	}
 
 	ret = crypto_shash_update(desc, &chap->id, 1);
 	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for id\n");
+		target_err("crypto_shash_update() failed for id\n");
 		goto out;
 	}
 
 	ret = crypto_shash_update(desc, (char *)&auth->password,
 				  strlen(auth->password));
 	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for password\n");
+		target_err("crypto_shash_update() failed for password\n");
 		goto out;
 	}
 
 	ret = crypto_shash_finup(desc, chap->challenge,
 				 chap->challenge_len, server_digest);
 	if (ret < 0) {
-		pr_err("crypto_shash_finup() failed for challenge\n");
+		target_err("crypto_shash_finup() failed for challenge\n");
 		goto out;
 	}
 
 	bin2hex(response, server_digest, chap->digest_size);
-	pr_debug("[server] %s Server Digest: %s\n",
-		chap->digest_name, response);
+	target_debug("[server] %s Server Digest: %s\n", chap->digest_name, response);
 
 	if (memcmp(server_digest, client_digest, chap->digest_size) != 0) {
-		pr_debug("[server] %s Digests do not match!\n\n",
-			chap->digest_name);
+		target_debug("[server] %s Digests do not match!\n\n", chap->digest_name);
 		goto out;
 	} else
-		pr_debug("[server] %s Digests match, CHAP connection"
-				" successful.\n\n", chap->digest_name);
+		target_debug("[server] %s Digests match, CHAP connection"
+			     " successful.\n\n",
+			     chap->digest_name);
 	/*
 	 * One way authentication has succeeded, return now if mutual
 	 * authentication is not enabled.
@@ -418,12 +417,12 @@ static int chap_server_compute_hash(
 	 */
 	ret = extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type);
 	if (ret == -ENOENT) {
-		pr_debug("Could not find CHAP_I. Initiator uses One way authentication.\n");
+		target_debug("Could not find CHAP_I. Initiator uses One way authentication.\n");
 		auth_ret = 0;
 		goto out;
 	}
 	if (ret < 0) {
-		pr_err("Could not find CHAP_I.\n");
+		target_err("Could not find CHAP_I.\n");
 		goto out;
 	}
 
@@ -433,23 +432,23 @@ static int chap_server_compute_hash(
 		ret = kstrtoul(identifier, 0, &id);
 
 	if (ret < 0) {
-		pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret);
+		target_err("kstrtoul() failed for CHAP identifier: %d\n", ret);
 		goto out;
 	}
 	if (id > 255) {
-		pr_err("chap identifier: %lu greater than 255\n", id);
+		target_err("chap identifier: %lu greater than 255\n", id);
 		goto out;
 	}
 	/*
 	 * RFC 1994 says Identifier is no more than octet (8 bits).
 	 */
-	pr_debug("[server] Got CHAP_I=%lu\n", id);
+	target_debug("[server] Got CHAP_I=%lu\n", id);
 	/*
 	 * Get CHAP_C.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_C", CHAP_CHALLENGE_STR_LEN,
 			initiatorchg, &type) < 0) {
-		pr_err("Could not find CHAP_C.\n");
+		target_err("Could not find CHAP_C.\n");
 		goto out;
 	}
 
@@ -457,17 +456,17 @@ static int chap_server_compute_hash(
 	case HEX:
 		initiatorchg_len = DIV_ROUND_UP(strlen(initiatorchg), 2);
 		if (!initiatorchg_len) {
-			pr_err("Unable to convert incoming challenge\n");
+			target_err("Unable to convert incoming challenge\n");
 			goto out;
 		}
 		if (initiatorchg_len > 1024) {
-			pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
+			target_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
 			goto out;
 		}
 
 		if (hex2bin(initiatorchg_binhex, initiatorchg,
 			    initiatorchg_len) < 0) {
-			pr_err("Malformed CHAP_C: invalid HEX\n");
+			target_err("Malformed CHAP_C: invalid HEX\n");
 			goto out;
 		}
 		break;
@@ -476,24 +475,24 @@ static int chap_server_compute_hash(
 						      initiatorchg,
 						      strlen(initiatorchg));
 		if (initiatorchg_len < 0) {
-			pr_err("Malformed CHAP_C: invalid BASE64\n");
+			target_err("Malformed CHAP_C: invalid BASE64\n");
 			goto out;
 		}
 		if (!initiatorchg_len) {
-			pr_err("Unable to convert incoming challenge\n");
+			target_err("Unable to convert incoming challenge\n");
 			goto out;
 		}
 		if (initiatorchg_len > 1024) {
-			pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
+			target_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
 			goto out;
 		}
 		break;
 	default:
-		pr_err("Could not find CHAP_C.\n");
+		target_err("Could not find CHAP_C.\n");
 		goto out;
 	}
 
-	pr_debug("[server] Got CHAP_C=%s\n", initiatorchg);
+	target_debug("[server] Got CHAP_C=%s\n", initiatorchg);
 	/*
 	 * During mutual authentication, the CHAP_C generated by the
 	 * initiator must not match the original CHAP_C generated by
@@ -502,8 +501,8 @@ static int chap_server_compute_hash(
 	if (initiatorchg_len == chap->challenge_len &&
 				!memcmp(initiatorchg_binhex, chap->challenge,
 				initiatorchg_len)) {
-		pr_err("initiator CHAP_C matches target CHAP_C, failing"
-		       " login attempt\n");
+		target_err("initiator CHAP_C matches target CHAP_C, failing"
+			   " login attempt\n");
 		goto out;
 	}
 	/*
@@ -511,7 +510,7 @@ static int chap_server_compute_hash(
 	 */
 	ret = crypto_shash_init(desc);
 	if (ret < 0) {
-		pr_err("crypto_shash_init() failed\n");
+		target_err("crypto_shash_init() failed\n");
 		goto out;
 	}
 
@@ -519,15 +518,15 @@ static int chap_server_compute_hash(
 	id_as_uchar = id;
 	ret = crypto_shash_update(desc, &id_as_uchar, 1);
 	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for id\n");
+		target_err("crypto_shash_update() failed for id\n");
 		goto out;
 	}
 
 	ret = crypto_shash_update(desc, auth->password_mutual,
 				  strlen(auth->password_mutual));
 	if (ret < 0) {
-		pr_err("crypto_shash_update() failed for"
-				" password_mutual\n");
+		target_err("crypto_shash_update() failed for"
+			   " password_mutual\n");
 		goto out;
 	}
 	/*
@@ -536,7 +535,7 @@ static int chap_server_compute_hash(
 	ret = crypto_shash_finup(desc, initiatorchg_binhex, initiatorchg_len,
 				 digest);
 	if (ret < 0) {
-		pr_err("crypto_shash_finup() failed for ma challenge\n");
+		target_err("crypto_shash_finup() failed for ma challenge\n");
 		goto out;
 	}
 
@@ -545,7 +544,7 @@ static int chap_server_compute_hash(
 	 */
 	*nr_out_len = sprintf(nr_out_ptr, "CHAP_N=%s", auth->userid_mutual);
 	*nr_out_len += 1;
-	pr_debug("[server] Sending CHAP_N=%s\n", auth->userid_mutual);
+	target_debug("[server] Sending CHAP_N=%s\n", auth->userid_mutual);
 	/*
 	 * Convert response from binary hex to ascii hext.
 	 */
@@ -553,7 +552,7 @@ static int chap_server_compute_hash(
 	*nr_out_len += sprintf(nr_out_ptr + *nr_out_len, "CHAP_R=0x%s",
 			response);
 	*nr_out_len += 1;
-	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
+	target_debug("[server] Sending CHAP_R=0x%s\n", response);
 	auth_ret = 0;
 out:
 	kfree_sensitive(desc);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 88db94f382bb..8f2578bf8621 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -67,13 +67,13 @@ static ssize_t lio_target_np_driver_store(struct config_item *item,
 	if (rc)
 		return rc;
 	if ((op != 1) && (op != 0)) {
-		pr_err("Illegal value for tpg_enable: %u\n", op);
+		target_err("Illegal value for tpg_enable: %u\n", op);
 		return -EINVAL;
 	}
 	np = tpg_np->tpg_np;
 	if (!np) {
-		pr_err("Unable to locate struct iscsi_np from"
-				" struct iscsi_tpg_np\n");
+		target_err("Unable to locate struct iscsi_np from"
+			   " struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
 
@@ -85,8 +85,7 @@ static ssize_t lio_target_np_driver_store(struct config_item *item,
 		if (strlen(mod_name)) {
 			rc = request_module(mod_name);
 			if (rc != 0) {
-				pr_warn("Unable to request_module for %s\n",
-					mod_name);
+				target_warn("Unable to request_module for %s\n", mod_name);
 				rc = 0;
 			}
 		}
@@ -164,8 +163,8 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	char buf[MAX_PORTAL_LEN + 1] = { };
 
 	if (strlen(name) > MAX_PORTAL_LEN) {
-		pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
-			(int)strlen(name), MAX_PORTAL_LEN);
+		target_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n", (int)strlen(name),
+			   MAX_PORTAL_LEN);
 		return ERR_PTR(-EOVERFLOW);
 	}
 	snprintf(buf, MAX_PORTAL_LEN + 1, "%s", name);
@@ -174,8 +173,8 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (str) {
 		str2 = strstr(str, "]");
 		if (!str2) {
-			pr_err("Unable to locate trailing \"]\""
-				" in IPv6 iSCSI network portal address\n");
+			target_err("Unable to locate trailing \"]\""
+				   " in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 
@@ -185,8 +184,8 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 
 		port_str = strstr(str2, ":");
 		if (!port_str) {
-			pr_err("Unable to locate \":port\""
-				" in IPv6 iSCSI network portal address\n");
+			target_err("Unable to locate \":port\""
+				   " in IPv6 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 		*port_str = '\0'; /* Terminate string for IP */
@@ -195,8 +194,8 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		ip_str = &buf[0];
 		port_str = strstr(ip_str, ":");
 		if (!port_str) {
-			pr_err("Unable to locate \":port\""
-				" in IPv4 iSCSI network portal address\n");
+			target_err("Unable to locate \":port\""
+				   " in IPv4 iSCSI network portal address\n");
 			return ERR_PTR(-EINVAL);
 		}
 		*port_str = '\0'; /* Terminate string for IP */
@@ -206,7 +205,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	ret = inet_pton_with_scope(&init_net, AF_UNSPEC, ip_str,
 			port_str, &sockaddr);
 	if (ret) {
-		pr_err("malformed ip/port passed: %s\n", name);
+		target_err("malformed ip/port passed: %s\n", name);
 		return ERR_PTR(ret);
 	}
 
@@ -215,10 +214,9 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	if (ret < 0)
 		return ERR_PTR(-EINVAL);
 
-	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
-		" PORTAL: %s\n",
-		config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
-		tpg->tpgt, name);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu"
+		     " PORTAL: %s\n",
+		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt, name);
 	/*
 	 * Assume ISCSI_TCP by default.  Other network portals for other
 	 * iSCSI fabrics:
@@ -238,7 +236,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 		iscsit_put_tpg(tpg);
 		return ERR_CAST(tpg_np);
 	}
-	pr_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
+	target_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
 
 	iscsit_put_tpg(tpg);
 	return &tpg_np->se_tpg_np;
@@ -259,15 +257,16 @@ static void lio_target_call_delnpfromtpg(
 		return;
 
 	se_tpg = &tpg->tpg_se_tpg;
-	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
-		" PORTAL: %pISpc\n", config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item),
-		tpg->tpgt, &tpg_np->tpg_np->np_sockaddr);
+	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s TPGT: %hu"
+		     " PORTAL: %pISpc\n",
+		     config_item_name(&se_tpg->se_tpg_wwn->wwn_group.cg_item), tpg->tpgt,
+		     &tpg_np->tpg_np->np_sockaddr);
 
 	ret = iscsit_tpg_del_network_portal(tpg, tpg_np);
 	if (ret < 0)
 		goto out;
 
-	pr_debug("LIO_Target_ConfigFS: delnpfromtpg done!\n");
+	target_debug("LIO_Target_ConfigFS: delnpfromtpg done!\n");
 out:
 	iscsit_put_tpg(tpg);
 }
@@ -658,24 +657,24 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 	if (ret)
 		return ret;
 	if (cmdsn_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		pr_err("Passed cmdsn_depth: %u exceeds"
-			" TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n", cmdsn_depth,
-			TA_DEFAULT_CMDSN_DEPTH_MAX);
+		target_err("Passed cmdsn_depth: %u exceeds"
+			   " TA_DEFAULT_CMDSN_DEPTH_MAX: %u\n",
+			   cmdsn_depth, TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	}
 	acl_ci = &se_nacl->acl_group.cg_item;
 	if (!acl_ci) {
-		pr_err("Unable to locatel acl_ci\n");
+		target_err("Unable to locatel acl_ci\n");
 		return -EINVAL;
 	}
 	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
 	if (!tpg_ci) {
-		pr_err("Unable to locate tpg_ci\n");
+		target_err("Unable to locate tpg_ci\n");
 		return -EINVAL;
 	}
 	wwn_ci = &tpg_ci->ci_group->cg_item;
 	if (!wwn_ci) {
-		pr_err("Unable to locate config_item wwn_ci\n");
+		target_err("Unable to locate config_item wwn_ci\n");
 		return -EINVAL;
 	}
 
@@ -684,10 +683,10 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 
 	ret = core_tpg_set_initiator_node_queue_depth(se_nacl, cmdsn_depth);
 
-	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
-		"InitiatorName: %s\n", config_item_name(wwn_ci),
-		config_item_name(tpg_ci), cmdsn_depth,
-		config_item_name(acl_ci));
+	target_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
+		     "InitiatorName: %s\n",
+		     config_item_name(wwn_ci), config_item_name(tpg_ci), cmdsn_depth,
+		     config_item_name(acl_ci));
 
 	iscsit_put_tpg(tpg);
 	return (!ret) ? count : (ssize_t)ret;
@@ -1053,8 +1052,8 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
 	 */
 	tpgt_str = strstr(name, "tpgt_");
 	if (!tpgt_str) {
-		pr_err("Unable to locate \"tpgt_#\" directory"
-				" group\n");
+		target_err("Unable to locate \"tpgt_#\" directory"
+			   " group\n");
 		return NULL;
 	}
 	tpgt_str += 5; /* Skip ahead of "tpgt_" */
@@ -1074,9 +1073,8 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
 	if (ret != 0)
 		goto out;
 
-	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	pr_debug("LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n",
-			name);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated TPG: %s\n", name);
 	return &tpg->tpg_se_tpg;
 out:
 	core_tpg_deregister(&tpg->tpg_se_tpg);
@@ -1125,7 +1123,7 @@ static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 	/*
 	 * iscsit_tpg_del_portal_group() assumes force=1
 	 */
-	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
+	target_debug("LIO_Target_ConfigFS: DEREGISTER -> Releasing TPG\n");
 	iscsit_tpg_del_portal_group(tiqn, tpg, 1);
 }
 
@@ -1193,9 +1191,10 @@ static struct se_wwn *lio_target_call_coreaddtiqn(
 	if (IS_ERR(tiqn))
 		return ERR_CAST(tiqn);
 
-	pr_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
-	pr_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
-			" %s\n", name);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> %s\n", tiqn->tiqn);
+	target_debug("LIO_Target_ConfigFS: REGISTER -> Allocated Node:"
+		     " %s\n",
+		     name);
 	return &tiqn->tiqn_wwn;
 }
 
@@ -1234,8 +1233,7 @@ static void lio_target_call_coredeltiqn(
 {
 	struct iscsi_tiqn *tiqn = container_of(wwn, struct iscsi_tiqn, tiqn_wwn);
 
-	pr_debug("LIO_Target_ConfigFS: DEREGISTER -> %s\n",
-			tiqn->tiqn);
+	target_debug("LIO_Target_ConfigFS: DEREGISTER -> %s\n", tiqn->tiqn);
 	iscsit_del_tiqn(tiqn);
 }
 
@@ -1296,13 +1294,14 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 	if (err)
 		return -EINVAL;
 	if ((op != 1) && (op != 0)) {
-		pr_err("Illegal value for enforce_discovery_auth:"
-				" %u\n", op);
+		target_err("Illegal value for enforce_discovery_auth:"
+			   " %u\n",
+			   op);
 		return -EINVAL;
 	}
 
 	if (!discovery_tpg) {
-		pr_err("iscsit_global->discovery_tpg is NULL\n");
+		target_err("iscsit_global->discovery_tpg is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1320,9 +1319,9 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
-		pr_debug("LIO-CORE[0] Successfully enabled"
-			" authentication enforcement for iSCSI"
-			" Discovery TPG\n");
+		target_debug("LIO-CORE[0] Successfully enabled"
+			     " authentication enforcement for iSCSI"
+			     " Discovery TPG\n");
 	} else {
 		/*
 		 * Reset the AuthMethod key to CHAP,None
@@ -1332,9 +1331,9 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
-		pr_debug("LIO-CORE[0] Successfully disabled"
-			" authentication enforcement for iSCSI"
-			" Discovery TPG\n");
+		target_debug("LIO-CORE[0] Successfully disabled"
+			     " authentication enforcement for iSCSI"
+			     " Discovery TPG\n");
 	}
 
 	return count;
@@ -1535,7 +1534,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 {
 	struct iscsit_cmd *cmd = container_of(se_cmd, struct iscsit_cmd, se_cmd);
 
-	pr_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
+	target_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
 	iscsit_release_cmd(cmd);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 2d44781be3c6..84ba97e935e1 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -23,8 +23,8 @@ struct iscsi_datain_req *iscsit_allocate_datain_req(void)
 
 	dr = kmem_cache_zalloc(lio_dr_cache, GFP_ATOMIC);
 	if (!dr) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_datain_req\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_datain_req\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&dr->cmd_datain_node);
@@ -63,8 +63,9 @@ void iscsit_free_all_datain_reqs(struct iscsit_cmd *cmd)
 struct iscsi_datain_req *iscsit_get_datain_req(struct iscsit_cmd *cmd)
 {
 	if (list_empty(&cmd->datain_list)) {
-		pr_err("cmd->datain_list is empty for ITT:"
-			" 0x%08x\n", cmd->init_task_tag);
+		target_err("cmd->datain_list is empty for ITT:"
+			   " 0x%08x\n",
+			   cmd->init_task_tag);
 		return NULL;
 	}
 
@@ -102,8 +103,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_yes(
 
 	read_data_left = (cmd->se_cmd.data_length - read_data_done);
 	if (!read_data_left) {
-		pr_err("ITT: 0x%08x read_data_left is zero!\n",
-				cmd->init_task_tag);
+		target_err("ITT: 0x%08x read_data_left is zero!\n", cmd->init_task_tag);
 		return NULL;
 	}
 
@@ -201,8 +201,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
 
 	read_data_left = (cmd->se_cmd.data_length - read_data_done);
 	if (!read_data_left) {
-		pr_err("ITT: 0x%08x read_data_left is zero!\n",
-				cmd->init_task_tag);
+		target_err("ITT: 0x%08x read_data_left is zero!\n", cmd->init_task_tag);
 		return NULL;
 	}
 
@@ -322,8 +321,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_no(
 
 	read_data_left = (cmd->se_cmd.data_length - read_data_done);
 	if (!read_data_left) {
-		pr_err("ITT: 0x%08x read_data_left is zero!\n",
-				cmd->init_task_tag);
+		target_err("ITT: 0x%08x read_data_left is zero!\n", cmd->init_task_tag);
 		return dr;
 	}
 
@@ -422,8 +420,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_no(
 
 	read_data_left = (cmd->se_cmd.data_length - read_data_done);
 	if (!read_data_left) {
-		pr_err("ITT: 0x%08x read_data_left is zero!\n",
-				cmd->init_task_tag);
+		target_err("ITT: 0x%08x read_data_left is zero!\n", cmd->init_task_tag);
 		return NULL;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index b565ce3b2677..466f27c93ca3 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -52,6 +52,6 @@ void iscsit_increment_maxcmdsn(struct iscsit_cmd *cmd, struct iscsit_session *se
 	cmd->maxcmdsn_inc = 1;
 
 	max_cmd_sn = atomic_inc_return(&sess->max_cmd_sn);
-	pr_debug("Updated MaxCmdSN to 0x%08x\n", max_cmd_sn);
+	target_debug("Updated MaxCmdSN to 0x%08x\n", max_cmd_sn);
 }
 EXPORT_SYMBOL(iscsit_increment_maxcmdsn);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 07e9cf431edd..800fe7b6322d 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -123,8 +123,9 @@ static int iscsit_dataout_within_command_recovery_check(
 	return DATAOUT_NORMAL;
 
 dump:
-	pr_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
-		" 0x%08x\n", hdr->offset, payload_length, hdr->datasn);
+	target_err("Dumping DataOUT PDU Offset: %u Length: %d DataSN:"
+		   " 0x%08x\n",
+		   hdr->offset, payload_length, hdr->datasn);
 	return iscsit_dump_data_payload(conn, payload_length, 1);
 }
 
@@ -140,20 +141,20 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 	if ((be32_to_cpu(hdr->offset) < cmd->seq_start_offset) ||
 	   ((be32_to_cpu(hdr->offset) + payload_length) > cmd->seq_end_offset)) {
-		pr_err("Command ITT: 0x%08x with Offset: %u,"
-		" Length: %u outside of Unsolicited Sequence %u:%u while"
-		" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
-		be32_to_cpu(hdr->offset), payload_length, cmd->seq_start_offset,
-			cmd->seq_end_offset);
+		target_err("Command ITT: 0x%08x with Offset: %u,"
+			   " Length: %u outside of Unsolicited Sequence %u:%u while"
+			   " DataSequenceInOrder=Yes.\n",
+			   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length,
+			   cmd->seq_start_offset, cmd->seq_end_offset);
 		return DATAOUT_CANNOT_RECOVER;
 	}
 
 	first_burst_len = (cmd->first_burst_len + payload_length);
 
 	if (first_burst_len > conn->sess->sess_ops->FirstBurstLength) {
-		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
-			" for this Unsolicited DataOut Burst.\n",
-			first_burst_len, conn->sess->sess_ops->FirstBurstLength);
+		target_err("Total %u bytes exceeds FirstBurstLength: %u"
+			   " for this Unsolicited DataOut Burst.\n",
+			   first_burst_len, conn->sess->sess_ops->FirstBurstLength);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 		return DATAOUT_CANNOT_RECOVER;
@@ -174,27 +175,28 @@ static int iscsit_dataout_check_unsolicited_sequence(
 
 		if ((first_burst_len != cmd->se_cmd.data_length) &&
 		    (first_burst_len != conn->sess->sess_ops->FirstBurstLength)) {
-			pr_err("Unsolicited non-immediate data"
-			" received %u does not equal FirstBurstLength: %u, and"
-			" does not equal ExpXferLen %u.\n", first_burst_len,
-				conn->sess->sess_ops->FirstBurstLength,
-				cmd->se_cmd.data_length);
+			target_err("Unsolicited non-immediate data"
+				   " received %u does not equal FirstBurstLength: %u, and"
+				   " does not equal ExpXferLen %u.\n",
+				   first_burst_len, conn->sess->sess_ops->FirstBurstLength,
+				   cmd->se_cmd.data_length);
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 	} else {
 		if (first_burst_len == conn->sess->sess_ops->FirstBurstLength) {
-			pr_err("Command ITT: 0x%08x reached"
-			" FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
-				" error.\n", cmd->init_task_tag,
-				conn->sess->sess_ops->FirstBurstLength);
+			target_err("Command ITT: 0x%08x reached"
+				   " FirstBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
+				   " error.\n",
+				   cmd->init_task_tag, conn->sess->sess_ops->FirstBurstLength);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 		if (first_burst_len == cmd->se_cmd.data_length) {
-			pr_err("Command ITT: 0x%08x reached"
-			" ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
-			" error.\n", cmd->init_task_tag, cmd->se_cmd.data_length);
+			target_err("Command ITT: 0x%08x reached"
+				   " ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
+				   " error.\n",
+				   cmd->init_task_tag, cmd->se_cmd.data_length);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 	}
@@ -228,11 +230,11 @@ static int iscsit_dataout_check_sequence(
 		 */
 		if ((be32_to_cpu(hdr->offset) < cmd->seq_start_offset) ||
 		   ((be32_to_cpu(hdr->offset) + payload_length) > cmd->seq_end_offset)) {
-			pr_err("Command ITT: 0x%08x with Offset: %u,"
-			" Length: %u outside of Sequence %u:%u while"
-			" DataSequenceInOrder=Yes.\n", cmd->init_task_tag,
-			be32_to_cpu(hdr->offset), payload_length, cmd->seq_start_offset,
-				cmd->seq_end_offset);
+			target_err("Command ITT: 0x%08x with Offset: %u,"
+				   " Length: %u outside of Sequence %u:%u while"
+				   " DataSequenceInOrder=Yes.\n",
+				   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length,
+				   cmd->seq_start_offset, cmd->seq_end_offset);
 
 			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
 				return DATAOUT_CANNOT_RECOVER;
@@ -260,11 +262,11 @@ static int iscsit_dataout_check_sequence(
 	}
 
 	if (next_burst_len > conn->sess->sess_ops->MaxBurstLength) {
-		pr_err("Command ITT: 0x%08x, NextBurstLength: %u and"
-			" Length: %u exceeds MaxBurstLength: %u. protocol"
-			" error.\n", cmd->init_task_tag,
-			(next_burst_len - payload_length),
-			payload_length, conn->sess->sess_ops->MaxBurstLength);
+		target_err("Command ITT: 0x%08x, NextBurstLength: %u and"
+			   " Length: %u exceeds MaxBurstLength: %u. protocol"
+			   " error.\n",
+			   cmd->init_task_tag, (next_burst_len - payload_length), payload_length,
+			   conn->sess->sess_ops->MaxBurstLength);
 		return DATAOUT_CANNOT_RECOVER;
 	}
 
@@ -286,16 +288,18 @@ static int iscsit_dataout_check_sequence(
 			     conn->sess->sess_ops->MaxBurstLength) &&
 			   ((cmd->write_data_done + payload_length) <
 			     cmd->se_cmd.data_length)) {
-				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
-				" before end of DataOUT sequence, protocol"
-				" error.\n", cmd->init_task_tag);
+				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+					   " before end of DataOUT sequence, protocol"
+					   " error.\n",
+					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		} else {
 			if (next_burst_len < seq->xfer_len) {
-				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
-				" before end of DataOUT sequence, protocol"
-				" error.\n", cmd->init_task_tag);
+				target_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
+					   " before end of DataOUT sequence, protocol"
+					   " error.\n",
+					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		}
@@ -303,26 +307,27 @@ static int iscsit_dataout_check_sequence(
 		if (conn->sess->sess_ops->DataSequenceInOrder) {
 			if (next_burst_len ==
 					conn->sess->sess_ops->MaxBurstLength) {
-				pr_err("Command ITT: 0x%08x reached"
-				" MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
-				" not set, protocol error.", cmd->init_task_tag,
-					conn->sess->sess_ops->MaxBurstLength);
+				target_err("Command ITT: 0x%08x reached"
+					   " MaxBurstLength: %u, but ISCSI_FLAG_CMD_FINAL is"
+					   " not set, protocol error.",
+					   cmd->init_task_tag,
+					   conn->sess->sess_ops->MaxBurstLength);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 			if ((cmd->write_data_done + payload_length) ==
 					cmd->se_cmd.data_length) {
-				pr_err("Command ITT: 0x%08x reached"
-				" last DataOUT PDU in sequence but ISCSI_FLAG_"
-				"CMD_FINAL is not set, protocol error.\n",
-					cmd->init_task_tag);
+				target_err("Command ITT: 0x%08x reached"
+					   " last DataOUT PDU in sequence but ISCSI_FLAG_"
+					   "CMD_FINAL is not set, protocol error.\n",
+					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		} else {
 			if (next_burst_len == seq->xfer_len) {
-				pr_err("Command ITT: 0x%08x reached"
-				" last DataOUT PDU in sequence but ISCSI_FLAG_"
-				"CMD_FINAL is not set, protocol error.\n",
-					cmd->init_task_tag);
+				target_err("Command ITT: 0x%08x reached"
+					   " last DataOUT PDU in sequence but ISCSI_FLAG_"
+					   "CMD_FINAL is not set, protocol error.\n",
+					   cmd->init_task_tag);
 				return DATAOUT_CANNOT_RECOVER;
 			}
 		}
@@ -357,14 +362,14 @@ static int iscsit_dataout_check_datasn(
 	}
 
 	if (be32_to_cpu(hdr->datasn) > data_sn) {
-		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
-			" higher than expected 0x%08x.\n", cmd->init_task_tag,
-				be32_to_cpu(hdr->datasn), data_sn);
+		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
+			   " higher than expected 0x%08x.\n",
+			   cmd->init_task_tag, be32_to_cpu(hdr->datasn), data_sn);
 		goto recover;
 	} else if (be32_to_cpu(hdr->datasn) < data_sn) {
-		pr_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
-			" lower than expected 0x%08x, discarding payload.\n",
-			cmd->init_task_tag, be32_to_cpu(hdr->datasn), data_sn);
+		target_err("Command ITT: 0x%08x, received DataSN: 0x%08x"
+			   " lower than expected 0x%08x, discarding payload.\n",
+			   cmd->init_task_tag, be32_to_cpu(hdr->datasn), data_sn);
 		goto dump;
 	}
 
@@ -372,8 +377,8 @@ static int iscsit_dataout_check_datasn(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		pr_err("Unable to perform within-command recovery"
-				" while ERL=0.\n");
+		target_err("Unable to perform within-command recovery"
+			   " while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
 dump:
@@ -403,9 +408,10 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 	 */
 	if (conn->sess->sess_ops->DataSequenceInOrder) {
 		if (be32_to_cpu(hdr->offset) != cmd->write_data_done) {
-			pr_err("Command ITT: 0x%08x, received offset"
-			" %u different than expected %u.\n", cmd->init_task_tag,
-				be32_to_cpu(hdr->offset), cmd->write_data_done);
+			target_err("Command ITT: 0x%08x, received offset"
+				   " %u different than expected %u.\n",
+				   cmd->init_task_tag, be32_to_cpu(hdr->offset),
+				   cmd->write_data_done);
 			recovery = 1;
 			goto recover;
 		}
@@ -413,16 +419,15 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 		struct iscsi_seq *seq = cmd->seq_ptr;
 
 		if (be32_to_cpu(hdr->offset) > seq->offset) {
-			pr_err("Command ITT: 0x%08x, received offset"
-			" %u greater than expected %u.\n", cmd->init_task_tag,
-				be32_to_cpu(hdr->offset), seq->offset);
+			target_err("Command ITT: 0x%08x, received offset"
+				   " %u greater than expected %u.\n",
+				   cmd->init_task_tag, be32_to_cpu(hdr->offset), seq->offset);
 			recovery = 1;
 			goto recover;
 		} else if (be32_to_cpu(hdr->offset) < seq->offset) {
-			pr_err("Command ITT: 0x%08x, received offset"
-			" %u less than expected %u, discarding payload.\n",
-				cmd->init_task_tag, be32_to_cpu(hdr->offset),
-				seq->offset);
+			target_err("Command ITT: 0x%08x, received offset"
+				   " %u less than expected %u, discarding payload.\n",
+				   cmd->init_task_tag, be32_to_cpu(hdr->offset), seq->offset);
 			dump = 1;
 			goto dump;
 		}
@@ -432,8 +437,8 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 
 recover:
 	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-		pr_err("Unable to perform within-command recovery"
-				" while ERL=0.\n");
+		target_err("Unable to perform within-command recovery"
+			   " while ERL=0.\n");
 		return DATAOUT_CANNOT_RECOVER;
 	}
 dump:
@@ -466,9 +471,9 @@ static int iscsit_dataout_pre_datapduinorder_no(
 	case ISCSI_PDU_TIMED_OUT:
 		break;
 	case ISCSI_PDU_RECEIVED_OK:
-		pr_err("Command ITT: 0x%08x received already gotten"
-			" Offset: %u, Length: %u\n", cmd->init_task_tag,
-				be32_to_cpu(hdr->offset), payload_length);
+		target_err("Command ITT: 0x%08x received already gotten"
+			   " Offset: %u, Length: %u\n",
+			   cmd->init_task_tag, be32_to_cpu(hdr->offset), payload_length);
 		return iscsit_dump_data_payload(cmd->conn, payload_length, 1);
 	default:
 		return DATAOUT_CANNOT_RECOVER;
@@ -729,8 +734,8 @@ int iscsit_check_post_dataout(
 		return iscsit_dataout_post_crc_passed(cmd, buf);
 	else {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from DataOUT CRC"
-				" failure while ERL=0, closing session.\n");
+			target_err("Unable to recover from DataOUT CRC"
+				   " failure while ERL=0, closing session.\n");
 			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
 					  buf);
 			return DATAOUT_CANNOT_RECOVER;
@@ -753,15 +758,16 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 		return;
 	}
 	if (atomic_read(&sess->session_reinstatement)) {
-		pr_err("Exiting Time2Retain handler because"
-				" session_reinstatement=1\n");
+		target_err("Exiting Time2Retain handler because"
+			   " session_reinstatement=1\n");
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
 	sess->time2retain_timer_flags |= ISCSI_TF_EXPIRED;
 
-	pr_err("Time2Retain timer expired for SID: %u, cleaning up"
-			" iSCSI session.\n", sess->sid);
+	target_err("Time2Retain timer expired for SID: %u, cleaning up"
+		   " iSCSI session.\n",
+		   sess->sid);
 
 	iscsit_fill_cxn_timeout_err_stats(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
@@ -785,8 +791,9 @@ void iscsit_start_time2retain_handler(struct iscsit_session *sess)
 	if (sess->time2retain_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	pr_debug("Starting Time2Retain timer for %u seconds on"
-		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
+	target_debug("Starting Time2Retain timer for %u seconds on"
+		     " SID: %u\n",
+		     sess->sess_ops->DefaultTime2Retain, sess->sid);
 
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
 	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
@@ -814,8 +821,7 @@ int iscsit_stop_time2retain_timer(struct iscsit_session *sess)
 
 	spin_lock(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
-	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
-			sess->sid);
+	target_debug("Stopped Time2Retain Timer for SID: %u\n", sess->sid);
 	return 0;
 }
 
@@ -882,8 +888,9 @@ EXPORT_SYMBOL(iscsit_cause_connection_reinstatement);
 
 void iscsit_fall_back_to_erl0(struct iscsit_session *sess)
 {
-	pr_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
-			" %u\n", sess->sid);
+	target_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
+		     " %u\n",
+		     sess->sid);
 
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
 }
@@ -897,9 +904,9 @@ static void iscsit_handle_connection_cleanup(struct iscsit_conn *conn)
 	    !atomic_read(&sess->session_fall_back_to_erl0))
 		iscsit_connection_recovery_transport_reset(conn);
 	else {
-		pr_debug("Performing cleanup for failed iSCSI"
-			" Connection ID: %hu from %s\n", conn->cid,
-			sess->sess_ops->InitiatorName);
+		target_debug("Performing cleanup for failed iSCSI"
+			     " Connection ID: %hu from %s\n",
+			     conn->cid, sess->sess_ops->InitiatorName);
 		iscsit_close_connection(conn);
 	}
 }
@@ -927,7 +934,7 @@ void iscsit_take_action_for_connection_exit(struct iscsit_conn *conn, bool *conn
 		return;
 	}
 
-	pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+	target_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
 	conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
 	spin_unlock_bh(&conn->state_lock);
 
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d9a6242264b7..210530b586ef 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -58,8 +58,9 @@ int iscsit_dump_data_payload(
 
 	buf = kzalloc(length, GFP_ATOMIC);
 	if (!buf) {
-		pr_err("Unable to allocate %u bytes for offload"
-				" buffer.\n", length);
+		target_err("Unable to allocate %u bytes for offload"
+			   " buffer.\n",
+			   length);
 		return -1;
 	}
 	memset(&iov, 0, sizeof(struct kvec));
@@ -123,21 +124,21 @@ static int iscsit_handle_r2t_snack(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		pr_err("ITT: 0x%08x, R2T SNACK requesting"
-			" retransmission of R2TSN: 0x%08x to 0x%08x but already"
-			" acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
-			" protocol error.\n", cmd->init_task_tag, begrun,
-			(begrun + runlength), cmd->acked_data_sn);
+		target_err("ITT: 0x%08x, R2T SNACK requesting"
+			   " retransmission of R2TSN: 0x%08x to 0x%08x but already"
+			   " acked to  R2TSN: 0x%08x by TMR TASK_REASSIGN,"
+			   " protocol error.\n",
+			   cmd->init_task_tag, begrun, (begrun + runlength), cmd->acked_data_sn);
 
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
 
 	if (runlength) {
 		if ((begrun + runlength) > cmd->r2t_sn) {
-			pr_err("Command ITT: 0x%08x received R2T SNACK"
-			" with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
-			" current R2TSN: 0x%08x, protocol error.\n",
-			cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
+			target_err("Command ITT: 0x%08x received R2T SNACK"
+				   " with BegRun: 0x%08x, RunLength: 0x%08x, exceeds"
+				   " current R2TSN: 0x%08x, protocol error.\n",
+				   cmd->init_task_tag, begrun, runlength, cmd->r2t_sn);
 			return iscsit_reject_cmd(cmd,
 					ISCSI_REASON_BOOKMARK_INVALID, buf);
 		}
@@ -224,7 +225,7 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 	struct iscsi_seq *first_seq = NULL, *seq = NULL;
 
 	if (!cmd->seq_list) {
-		pr_err("struct iscsit_cmd->seq_list is NULL!\n");
+		target_err("struct iscsit_cmd->seq_list is NULL!\n");
 		return -1;
 	}
 
@@ -248,9 +249,9 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 * seq->first_datasn and seq->last_datasn have not been set.
 		 */
 		if (!seq->sent) {
-			pr_err("Ignoring non-sent sequence 0x%08x ->"
-				" 0x%08x\n\n", seq->first_datasn,
-				seq->last_datasn);
+			target_err("Ignoring non-sent sequence 0x%08x ->"
+				   " 0x%08x\n\n",
+				   seq->first_datasn, seq->last_datasn);
 			continue;
 		}
 
@@ -261,9 +262,9 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if ((seq->first_datasn < begrun) &&
 				(seq->last_datasn < begrun)) {
-			pr_err("Pre BegRun sequence 0x%08x ->"
-				" 0x%08x\n", seq->first_datasn,
-				seq->last_datasn);
+			target_err("Pre BegRun sequence 0x%08x ->"
+				   " 0x%08x\n",
+				   seq->first_datasn, seq->last_datasn);
 
 			read_data_done += cmd->seq_list[i].xfer_len;
 			seq->next_burst_len = seq->pdu_send_order = 0;
@@ -275,9 +276,9 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if ((seq->first_datasn <= begrun) &&
 				(seq->last_datasn >= begrun)) {
-			pr_err("Found sequence begrun: 0x%08x in"
-				" 0x%08x -> 0x%08x\n", begrun,
-				seq->first_datasn, seq->last_datasn);
+			target_err("Found sequence begrun: 0x%08x in"
+				   " 0x%08x -> 0x%08x\n",
+				   begrun, seq->first_datasn, seq->last_datasn);
 
 			seq_send_order = seq->seq_send_order;
 			data_sn = seq->first_datasn;
@@ -334,8 +335,8 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 		 */
 		if ((seq->first_datasn > begrun) ||
 				(seq->last_datasn > begrun)) {
-			pr_err("Post BegRun sequence 0x%08x -> 0x%08x\n",
-					seq->first_datasn, seq->last_datasn);
+			target_err("Post BegRun sequence 0x%08x -> 0x%08x\n", seq->first_datasn,
+				   seq->last_datasn);
 
 			seq->next_burst_len = seq->pdu_send_order = 0;
 			continue;
@@ -345,9 +346,9 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 	if (!found_seq) {
 		if (!begrun) {
 			if (!first_seq) {
-				pr_err("ITT: 0x%08x, Begrun: 0x%08x"
-					" but first_seq is NULL\n",
-					cmd->init_task_tag, begrun);
+				target_err("ITT: 0x%08x, Begrun: 0x%08x"
+					   " but first_seq is NULL\n",
+					   cmd->init_task_tag, begrun);
 				return -1;
 			}
 			seq_send_order = first_seq->seq_send_order;
@@ -355,11 +356,11 @@ int iscsit_create_recovery_datain_values_datasequenceinorder_no(
 			goto done;
 		}
 
-		pr_err("Unable to locate struct iscsi_seq for ITT: 0x%08x,"
-			" BegRun: 0x%08x, RunLength: 0x%08x while"
-			" DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
-				cmd->init_task_tag, begrun, runlength,
-			(conn->sess->sess_ops->DataPDUInOrder) ? "Yes" : "No");
+		target_err("Unable to locate struct iscsi_seq for ITT: 0x%08x,"
+			   " BegRun: 0x%08x, RunLength: 0x%08x while"
+			   " DataSequenceInOrder=No and DataPDUInOrder=%s.\n",
+			   cmd->init_task_tag, begrun, runlength,
+			   (conn->sess->sess_ops->DataPDUInOrder) ? "Yes" : "No");
 		return -1;
 	}
 
@@ -381,8 +382,7 @@ static int iscsit_handle_recovery_datain(
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	if (!(se_cmd->transport_state & CMD_T_COMPLETE)) {
-		pr_err("Ignoring ITT: 0x%08x Data SNACK\n",
-				cmd->init_task_tag);
+		target_err("Ignoring ITT: 0x%08x Data SNACK\n", cmd->init_task_tag);
 		return 0;
 	}
 
@@ -392,11 +392,11 @@ static int iscsit_handle_recovery_datain(
 	 */
 	if ((cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 	    (begrun <= cmd->acked_data_sn)) {
-		pr_err("ITT: 0x%08x, Data SNACK requesting"
-			" retransmission of DataSN: 0x%08x to 0x%08x but"
-			" already acked to DataSN: 0x%08x by Data ACK SNACK,"
-			" protocol error.\n", cmd->init_task_tag, begrun,
-			(begrun + runlength), cmd->acked_data_sn);
+		target_err("ITT: 0x%08x, Data SNACK requesting"
+			   " retransmission of DataSN: 0x%08x to 0x%08x but"
+			   " already acked to DataSN: 0x%08x by Data ACK SNACK,"
+			   " protocol error.\n",
+			   cmd->init_task_tag, begrun, (begrun + runlength), cmd->acked_data_sn);
 
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
 	}
@@ -406,9 +406,9 @@ static int iscsit_handle_recovery_datain(
 	 * Note: (cmd->data_sn - 1) will carry the maximum DataSN sent.
 	 */
 	if ((begrun + runlength) > (cmd->data_sn - 1)) {
-		pr_err("Initiator requesting BegRun: 0x%08x, RunLength"
-			": 0x%08x greater than maximum DataSN: 0x%08x.\n",
-				begrun, runlength, (cmd->data_sn - 1));
+		target_err("Initiator requesting BegRun: 0x%08x, RunLength"
+			   ": 0x%08x greater than maximum DataSN: 0x%08x.\n",
+			   begrun, runlength, (cmd->data_sn - 1));
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID,
 					 buf);
 	}
@@ -455,8 +455,7 @@ int iscsit_handle_recovery_datain_or_r2t(
 		return iscsit_handle_recovery_datain(cmd, buf, begrun,
 				runlength);
 	default:
-		pr_err("Unknown cmd->data_direction: 0x%02x\n",
-				cmd->data_direction);
+		target_err("Unknown cmd->data_direction: 0x%02x\n", cmd->data_direction);
 		return -1;
 	}
 
@@ -478,10 +477,10 @@ int iscsit_handle_status_snack(
 	if (!begrun) {
 		begrun = conn->exp_statsn;
 	} else if (conn->exp_statsn > begrun) {
-		pr_err("Got Status SNACK Begrun: 0x%08x, RunLength:"
-			" 0x%08x but already got ExpStatSN: 0x%08x on CID:"
-			" %hu.\n", begrun, runlength, conn->exp_statsn,
-			conn->cid);
+		target_err("Got Status SNACK Begrun: 0x%08x, RunLength:"
+			   " 0x%08x but already got ExpStatSN: 0x%08x on CID:"
+			   " %hu.\n",
+			   begrun, runlength, conn->exp_statsn, conn->cid);
 		return 0;
 	}
 
@@ -500,10 +499,11 @@ int iscsit_handle_status_snack(
 		spin_unlock_bh(&conn->cmd_lock);
 
 		if (!found_cmd) {
-			pr_err("Unable to find StatSN: 0x%08x for"
-				" a Status SNACK, assuming this was a"
-				" protactic SNACK for an untransmitted"
-				" StatSN, ignoring.\n", begrun);
+			target_err("Unable to find StatSN: 0x%08x for"
+				   " a Status SNACK, assuming this was a"
+				   " protactic SNACK for an untransmitted"
+				   " StatSN, ignoring.\n",
+				   begrun);
 			begrun++;
 			continue;
 		}
@@ -511,10 +511,11 @@ int iscsit_handle_status_snack(
 		spin_lock_bh(&cmd->istate_lock);
 		if (cmd->i_state == ISTATE_SEND_DATAIN) {
 			spin_unlock_bh(&cmd->istate_lock);
-			pr_err("Ignoring Status SNACK for BegRun:"
-				" 0x%08x, RunLength: 0x%08x, assuming this was"
-				" a protactic SNACK for an untransmitted"
-				" StatSN\n", begrun, runlength);
+			target_err("Ignoring Status SNACK for BegRun:"
+				   " 0x%08x, RunLength: 0x%08x, assuming this was"
+				   " a protactic SNACK for an untransmitted"
+				   " StatSN\n",
+				   begrun, runlength);
 			begrun++;
 			continue;
 		}
@@ -538,15 +539,16 @@ int iscsit_handle_data_ack(
 
 	cmd = iscsit_find_cmd_from_ttt(conn, targ_xfer_tag);
 	if (!cmd) {
-		pr_err("Data ACK SNACK for TTT: 0x%08x is"
-			" invalid.\n", targ_xfer_tag);
+		target_err("Data ACK SNACK for TTT: 0x%08x is"
+			   " invalid.\n",
+			   targ_xfer_tag);
 		return -1;
 	}
 
 	if (begrun <= cmd->acked_data_sn) {
-		pr_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
-			" less than the already acked DataSN: 0x%08x.\n",
-			cmd->init_task_tag, begrun, cmd->acked_data_sn);
+		target_err("ITT: 0x%08x Data ACK SNACK BegRUN: 0x%08x is"
+			   " less than the already acked DataSN: 0x%08x.\n",
+			   cmd->init_task_tag, begrun, cmd->acked_data_sn);
 		return -1;
 	}
 
@@ -557,9 +559,9 @@ int iscsit_handle_data_ack(
 	cmd->cmd_flags |= ICF_GOT_DATACK_SNACK;
 	cmd->acked_data_sn = (begrun - 1);
 
-	pr_debug("Received Data ACK SNACK for ITT: 0x%08x,"
-		" updated acked DataSN to 0x%08x.\n",
-			cmd->init_task_tag, cmd->acked_data_sn);
+	target_debug("Received Data ACK SNACK for ITT: 0x%08x,"
+		     " updated acked DataSN to 0x%08x.\n",
+		     cmd->init_task_tag, cmd->acked_data_sn);
 
 	return 0;
 }
@@ -756,8 +758,8 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 
 	ooo_cmdsn = kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC);
 	if (!ooo_cmdsn) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_ooo_cmdsn.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_ooo_cmdsn.\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&ooo_cmdsn->ooo_list);
@@ -862,9 +864,9 @@ int iscsit_execute_ooo_cmdsns(struct iscsit_session *sess)
 		cmd->i_state = cmd->deferred_i_state;
 		ooo_count++;
 		sess->exp_cmd_sn++;
-		pr_debug("Executing out of order CmdSN: 0x%08x,"
-			" incremented ExpCmdSN to 0x%08x.\n",
-			cmd->cmd_sn, sess->exp_cmd_sn);
+		target_debug("Executing out of order CmdSN: 0x%08x,"
+			     " incremented ExpCmdSN to 0x%08x.\n",
+			     cmd->cmd_sn, sess->exp_cmd_sn);
 
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
 
@@ -977,16 +979,18 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 			lr = iscsit_logout_removeconnforrecovery(cmd, cmd->conn);
 			break;
 		default:
-			pr_err("Unknown iSCSI Logout Request Code:"
-				" 0x%02x\n", cmd->logout_reason);
+			target_err("Unknown iSCSI Logout Request Code:"
+				   " 0x%02x\n",
+				   cmd->logout_reason);
 			return -1;
 		}
 
 		return lr;
 	default:
 		spin_unlock_bh(&cmd->istate_lock);
-		pr_err("Cannot perform out of order execution for"
-		" unknown iSCSI Opcode: 0x%02x\n", cmd->iscsi_opcode);
+		target_err("Cannot perform out of order execution for"
+			   " unknown iSCSI Opcode: 0x%02x\n",
+			   cmd->iscsi_opcode);
 		return -1;
 	}
 
@@ -1066,7 +1070,7 @@ static int iscsit_set_dataout_timeout_values(
 
 	spin_lock_bh(&cmd->r2t_lock);
 	if (list_empty(&cmd->cmd_r2t_list)) {
-		pr_err("cmd->cmd_r2t_list is empty!\n");
+		target_err("cmd->cmd_r2t_list is empty!\n");
 		spin_unlock_bh(&cmd->r2t_lock);
 		return -1;
 	}
@@ -1081,8 +1085,9 @@ static int iscsit_set_dataout_timeout_values(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	pr_err("Unable to locate any incomplete DataOUT"
-		" sequences for ITT: 0x%08x.\n", cmd->init_task_tag);
+	target_err("Unable to locate any incomplete DataOUT"
+		   " sequences for ITT: 0x%08x.\n",
+		   cmd->init_task_tag);
 
 	return -1;
 }
@@ -1112,21 +1117,21 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 	na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!sess->sess_ops->ErrorRecoveryLevel) {
-		pr_err("Unable to recover from DataOut timeout while"
-			" in ERL=0, closing iSCSI connection for I_T Nexus"
-			" %s,i,0x%6phN,%s,t,0x%02x\n",
-			sess->sess_ops->InitiatorName, sess->isid,
-			sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
+		target_err("Unable to recover from DataOut timeout while"
+			   " in ERL=0, closing iSCSI connection for I_T Nexus"
+			   " %s,i,0x%6phN,%s,t,0x%02x\n",
+			   sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
+			   (u32)sess->tpg->tpgt);
 		goto failure;
 	}
 
 	if (++cmd->dataout_timeout_retries == na->dataout_timeout_retries) {
-		pr_err("Command ITT: 0x%08x exceeded max retries"
-			" for DataOUT timeout %u, closing iSCSI connection for"
-			" I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
-			cmd->init_task_tag, na->dataout_timeout_retries,
-			sess->sess_ops->InitiatorName, sess->isid,
-			sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
+		target_err("Command ITT: 0x%08x exceeded max retries"
+			   " for DataOUT timeout %u, closing iSCSI connection for"
+			   " I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+			   cmd->init_task_tag, na->dataout_timeout_retries,
+			   sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
+			   (u32)sess->tpg->tpgt);
 		goto failure;
 	}
 
@@ -1157,10 +1162,10 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 			&r2t_offset, &r2t_length) < 0)
 		goto failure;
 
-	pr_debug("Command ITT: 0x%08x timed out waiting for"
-		" completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
-		cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " :
-		"", r2t_offset, r2t_length);
+	target_debug("Command ITT: 0x%08x timed out waiting for"
+		     " completion of %sDataOUT Sequence Offset: %u, Length: %u\n",
+		     cmd->init_task_tag, (cmd->unsolicited_data) ? "Unsolicited " : "", r2t_offset,
+		     r2t_length);
 
 	if (iscsit_send_recovery_r2t(cmd, r2t_offset, r2t_length) < 0)
 		goto failure;
@@ -1192,8 +1197,7 @@ void iscsit_mod_dataout_timer(struct iscsit_cmd *cmd)
 
 	mod_timer(&cmd->dataout_timer,
 		(get_jiffies_64() + na->dataout_timeout * HZ));
-	pr_debug("Updated DataOUT timer for ITT: 0x%08x",
-			cmd->init_task_tag);
+	target_debug("Updated DataOUT timer for ITT: 0x%08x", cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
 
@@ -1209,8 +1213,9 @@ void iscsit_start_dataout_timer(
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
-		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
+	target_debug("Starting DataOUT timer for ITT: 0x%08x on"
+		     " CID: %hu.\n",
+		     cmd->init_task_tag, conn->cid);
 
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
@@ -1231,8 +1236,7 @@ void iscsit_stop_dataout_timer(struct iscsit_cmd *cmd)
 
 	spin_lock_bh(&cmd->dataout_timeout_lock);
 	cmd->dataout_timer_flags &= ~ISCSI_TF_RUNNING;
-	pr_debug("Stopped DataOUT Timer for ITT: 0x%08x\n",
-			cmd->init_task_tag);
+	target_debug("Stopped DataOUT Timer for ITT: 0x%08x\n", cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
 EXPORT_SYMBOL(iscsit_stop_dataout_timer);
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 18e88d2ea5fd..8b84ff97b0f0 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -92,8 +92,9 @@ static int iscsit_attach_inactive_connection_recovery_entry(
 	list_add_tail(&cr->cr_list, &sess->cr_inactive_list);
 
 	sess->conn_recovery_count++;
-	pr_debug("Incremented connection recovery count to %u for"
-		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	target_debug("Incremented connection recovery count to %u for"
+		     " SID: %u\n",
+		     sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_i_lock);
 
 	return 0;
@@ -175,8 +176,9 @@ int iscsit_remove_active_connection_recovery_entry(
 	list_del(&cr->cr_list);
 
 	sess->conn_recovery_count--;
-	pr_debug("Decremented connection recovery count to %u for"
-		" SID: %u\n", sess->conn_recovery_count, sess->sid);
+	target_debug("Decremented connection recovery count to %u for"
+		     " SID: %u\n",
+		     sess->conn_recovery_count, sess->sid);
 	spin_unlock(&sess->cr_a_lock);
 
 	kfree(cr);
@@ -203,8 +205,9 @@ int iscsit_remove_cmd_from_connection_recovery(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			" is NULL!\n", cmd->init_task_tag);
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+			   " is NULL!\n",
+			   cmd->init_task_tag);
 		BUG();
 	}
 	cr = cmd->cr;
@@ -232,9 +235,9 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 		}
 
 		dropped_count++;
-		pr_debug("Dropping Acknowledged ITT: 0x%08x, StatSN:"
-			" 0x%08x, CID: %hu.\n", cmd->init_task_tag,
-				cmd->stat_sn, cr->cid);
+		target_debug("Dropping Acknowledged ITT: 0x%08x, StatSN:"
+			     " 0x%08x, CID: %hu.\n",
+			     cmd->init_task_tag, cmd->stat_sn, cr->cid);
 
 		iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 
@@ -244,18 +247,19 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 	}
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 
-	pr_debug("Dropped %u total acknowledged commands on"
-		" CID: %hu less than old ExpStatSN: 0x%08x\n",
-			dropped_count, cr->cid, exp_statsn);
+	target_debug("Dropped %u total acknowledged commands on"
+		     " CID: %hu less than old ExpStatSN: 0x%08x\n",
+		     dropped_count, cr->cid, exp_statsn);
 
 	if (!cr->cmd_count) {
-		pr_debug("No commands to be reassigned for failed"
-			" connection CID: %hu on SID: %u\n",
-			cr->cid, sess->sid);
+		target_debug("No commands to be reassigned for failed"
+			     " connection CID: %hu on SID: %u\n",
+			     cr->cid, sess->sid);
 		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
 		iscsit_attach_active_connection_recovery_entry(sess, cr);
-		pr_debug("iSCSI connection recovery successful for CID:"
-			" %hu on SID: %u\n", cr->cid, sess->sid);
+		target_debug("iSCSI connection recovery successful for CID:"
+			     " %hu on SID: %u\n",
+			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	} else {
 		iscsit_remove_inactive_connection_recovery_entry(cr, sess);
@@ -278,9 +282,9 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 			continue;
 
 		dropped_count++;
-		pr_debug("Dropping unacknowledged CmdSN:"
-		" 0x%08x during connection recovery on CID: %hu\n",
-			ooo_cmdsn->cmdsn, conn->cid);
+		target_debug("Dropping unacknowledged CmdSN:"
+			     " 0x%08x during connection recovery on CID: %hu\n",
+			     ooo_cmdsn->cmdsn, conn->cid);
 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
 	}
 	mutex_unlock(&sess->cmdsn_mutex);
@@ -298,9 +302,9 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	pr_debug("Dropped %u total unacknowledged commands on CID:"
-		" %hu for ExpCmdSN: 0x%08x.\n", dropped_count, conn->cid,
-				sess->exp_cmd_sn);
+	target_debug("Dropped %u total unacknowledged commands on CID:"
+		     " %hu for ExpCmdSN: 0x%08x.\n",
+		     dropped_count, conn->cid, sess->exp_cmd_sn);
 	return 0;
 }
 
@@ -318,8 +322,8 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 	 */
 	cr = kzalloc(sizeof(struct iscsi_conn_recovery), GFP_KERNEL);
 	if (!cr) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_recovery.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_conn_recovery.\n");
 		return -1;
 	}
 	INIT_LIST_HEAD(&cr->cr_list);
@@ -339,10 +343,10 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 
 		if ((cmd->iscsi_opcode != ISCSI_OP_SCSI_CMD) &&
 		    (cmd->iscsi_opcode != ISCSI_OP_NOOP_OUT)) {
-			pr_debug("Not performing reallegiance on"
-				" Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
-				" CID: %hu\n", cmd->iscsi_opcode,
-				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
+			target_debug("Not performing reallegiance on"
+				     " Opcode: 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x,"
+				     " CID: %hu\n",
+				     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, conn->cid);
 
 			list_del_init(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
@@ -372,11 +376,11 @@ int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *conn)
 		}
 
 		cmd_count++;
-		pr_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x,"
-			" CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
-			" reallegiance.\n", cmd->iscsi_opcode,
-			cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
-			conn->cid);
+		target_debug("Preparing Opcode: 0x%02x, ITT: 0x%08x,"
+			     " CmdSN: 0x%08x, StatSN: 0x%08x, CID: %hu for"
+			     " reallegiance.\n",
+			     cmd->iscsi_opcode, cmd->init_task_tag, cmd->cmd_sn, cmd->stat_sn,
+			     conn->cid);
 
 		cmd->deferred_i_state = cmd->i_state;
 		cmd->i_state = ISTATE_IN_CONNECTION_RECOVERY;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 90b870f234f0..99dfe612bdcc 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -41,7 +41,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsit_conn *conn)
 
 	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
 	if (!login) {
-		pr_err("Unable to allocate memory for struct iscsi_login.\n");
+		target_err("Unable to allocate memory for struct iscsi_login.\n");
 		return NULL;
 	}
 	conn->login = login;
@@ -50,13 +50,13 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsit_conn *conn)
 
 	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
 	if (!login->req_buf) {
-		pr_err("Unable to allocate memory for response buffer.\n");
+		target_err("Unable to allocate memory for response buffer.\n");
 		goto out_login;
 	}
 
 	login->rsp_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
 	if (!login->rsp_buf) {
-		pr_err("Unable to allocate memory for request buffer.\n");
+		target_err("Unable to allocate memory for request buffer.\n");
 		goto out_req_buf;
 	}
 
@@ -86,13 +86,13 @@ int iscsi_login_setup_crypto(struct iscsit_conn *conn)
 	 */
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
-		pr_err("crypto_alloc_ahash() failed\n");
+		target_err("crypto_alloc_ahash() failed\n");
 		return -ENOMEM;
 	}
 
 	conn->conn_rx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!conn->conn_rx_hash) {
-		pr_err("ahash_request_alloc() failed for conn_rx_hash\n");
+		target_err("ahash_request_alloc() failed for conn_rx_hash\n");
 		crypto_free_ahash(tfm);
 		return -ENOMEM;
 	}
@@ -100,7 +100,7 @@ int iscsi_login_setup_crypto(struct iscsit_conn *conn)
 
 	conn->conn_tx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!conn->conn_tx_hash) {
-		pr_err("ahash_request_alloc() failed for conn_tx_hash\n");
+		target_err("ahash_request_alloc() failed for conn_tx_hash\n");
 		ahash_request_free(conn->conn_rx_hash);
 		conn->conn_rx_hash = NULL;
 		crypto_free_ahash(tfm);
@@ -117,9 +117,9 @@ static int iscsi_login_check_initiator_version(
 	u8 version_min)
 {
 	if ((version_max != 0x00) || (version_min != 0x00)) {
-		pr_err("Unsupported iSCSI IETF Pre-RFC Revision,"
-			" version Min/Max 0x%02x/0x%02x, rejecting login.\n",
-			version_min, version_max);
+		target_err("Unsupported iSCSI IETF Pre-RFC Revision,"
+			   " version Min/Max 0x%02x/0x%02x, rejecting login.\n",
+			   version_min, version_max);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_NO_VERSION);
 		return -1;
@@ -184,10 +184,10 @@ int iscsi_check_for_session_reinstatement(struct iscsit_conn *conn)
 	if (!sess)
 		return 0;
 
-	pr_debug("%s iSCSI Session SID %u is still active for %s,"
-		" performing session reinstatement.\n", (sessiontype) ?
-		"Discovery" : "Normal", sess->sid,
-		sess->sess_ops->InitiatorName);
+	target_debug("%s iSCSI Session SID %u is still active for %s,"
+		     " performing session reinstatement.\n",
+		     (sessiontype) ? "Discovery" : "Normal", sess->sid,
+		     sess->sess_ops->InitiatorName);
 
 	spin_lock_bh(&sess->conn_lock);
 	if (sess->session_state == TARG_SESS_STATE_FAILED) {
@@ -264,7 +264,7 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		pr_err("Could not allocate memory for session\n");
+		target_err("Could not allocate memory for session\n");
 		return -ENOMEM;
 	}
 
@@ -294,7 +294,7 @@ static int iscsi_login_zero_tsih_s1(
 
 	ret = ida_alloc(&sess_ida, GFP_KERNEL);
 	if (ret < 0) {
-		pr_err("Session ID allocation failed %d\n", ret);
+		target_err("Session ID allocation failed %d\n", ret);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		goto free_sess;
@@ -312,8 +312,8 @@ static int iscsi_login_zero_tsih_s1(
 	if (!sess->sess_ops) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_sess_ops.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_sess_ops.\n");
 		goto free_id;
 	}
 
@@ -442,8 +442,9 @@ static int iscsi_login_zero_tsih_s2(
 		else
 			mrdsl -= off;
 
-		pr_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
-			" to PAGE_SIZE\n", mrdsl);
+		target_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
+			    " to PAGE_SIZE\n",
+			    mrdsl);
 
 		if (iscsi_change_param_sprintf(conn, "MaxRecvDataSegmentLength=%lu\n", mrdsl))
 			return -1;
@@ -462,8 +463,8 @@ static int iscsi_login_zero_tsih_s2(
 			if (iscsi_change_param_sprintf(conn, "InitialR2T=Yes"))
 				return -1;
 
-			pr_debug("Forcing ImmediateData=No + InitialR2T=Yes for"
-				 " T10-PI enabled ISER session\n");
+			target_debug("Forcing ImmediateData=No + InitialR2T=Yes for"
+				     " T10-PI enabled ISER session\n");
 		}
 	}
 
@@ -517,8 +518,8 @@ static int iscsi_login_non_zero_tsih_s2(
 	 * If the Time2Retain handler has expired, the session is already gone.
 	 */
 	if (!sess) {
-		pr_err("Initiator attempting to add a connection to"
-			" a non-existent session, rejecting iSCSI Login.\n");
+		target_err("Initiator attempting to add a connection to"
+			   " a non-existent session, rejecting iSCSI Login.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_NO_SESSION);
 		return -1;
@@ -576,9 +577,9 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 */
 	conn_ptr = iscsit_get_conn_from_cid_rcfr(sess, cid);
 	if (conn_ptr) {
-		pr_err("Connection exists with CID %hu for %s,"
-			" performing connection reinstatement.\n",
-			conn_ptr->cid, sess->sess_ops->InitiatorName);
+		target_err("Connection exists with CID %hu for %s,"
+			   " performing connection reinstatement.\n",
+			   conn_ptr->cid, sess->sess_ops->InitiatorName);
 
 		iscsit_connection_reinstatement_rcfr(conn_ptr);
 		iscsit_dec_conn_usage_count(conn_ptr);
@@ -597,9 +598,9 @@ int iscsi_login_post_auth_non_zero_tsih(
 		cr = iscsit_get_inactive_connection_recovery_entry(
 				sess, cid);
 		if (cr) {
-			pr_debug("Performing implicit logout"
-				" for connection recovery on CID: %hu\n",
-					conn->cid);
+			target_debug("Performing implicit logout"
+				     " for connection recovery on CID: %hu\n",
+				     conn->cid);
 			iscsit_discard_cr_cmds_by_expstatsn(cr, exp_statsn);
 		}
 	}
@@ -610,13 +611,13 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 * CID we go ahead and continue to add a new connection to the
 	 * session.
 	 */
-	pr_debug("Adding CID %hu to existing session for %s.\n",
-			cid, sess->sess_ops->InitiatorName);
+	target_debug("Adding CID %hu to existing session for %s.\n", cid,
+		     sess->sess_ops->InitiatorName);
 
 	if ((atomic_read(&sess->nconn) + 1) > sess->sess_ops->MaxConnections) {
-		pr_err("Adding additional connection to this session"
-			" would exceed MaxConnections %d, login failed.\n",
-				sess->sess_ops->MaxConnections);
+		target_err("Adding additional connection to this session"
+			   " would exceed MaxConnections %d, login failed.\n",
+			   sess->sess_ops->MaxConnections);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_ISID_ERROR);
 		return -1;
@@ -648,15 +649,15 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	if (conn->bitmap_id < 0) {
-		pr_err("bitmap_find_free_region() failed for"
-		       " iscsit_start_kthreads()\n");
+		target_err("bitmap_find_free_region() failed for"
+			   " iscsit_start_kthreads()\n");
 		return -ENOMEM;
 	}
 
 	conn->tx_thread = kthread_run(iscsi_target_tx_thread, conn,
 				      "%s", ISCSI_TX_THREAD_NAME);
 	if (IS_ERR(conn->tx_thread)) {
-		pr_err("Unable to start iscsi_target_tx_thread\n");
+		target_err("Unable to start iscsi_target_tx_thread\n");
 		ret = PTR_ERR(conn->tx_thread);
 		goto out_bitmap;
 	}
@@ -665,7 +666,7 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	conn->rx_thread = kthread_run(iscsi_target_rx_thread, conn,
 				      "%s", ISCSI_RX_THREAD_NAME);
 	if (IS_ERR(conn->rx_thread)) {
-		pr_err("Unable to start iscsi_target_rx_thread\n");
+		target_err("Unable to start iscsi_target_rx_thread\n");
 		ret = PTR_ERR(conn->rx_thread);
 		goto out_tx;
 	}
@@ -700,7 +701,7 @@ void iscsi_post_login_handler(
 	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_SUCCESS,
 			ISCSI_LOGIN_STATUS_ACCEPT);
 
-	pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
+	target_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
 	conn->conn_state = TARG_CONN_STATE_LOGGED_IN;
 
 	iscsi_set_connection_parameters(conn->conn_ops, conn->param_list);
@@ -716,21 +717,21 @@ void iscsi_post_login_handler(
 		spin_lock_bh(&sess->conn_lock);
 		atomic_set(&sess->session_continuation, 0);
 		if (sess->session_state == TARG_SESS_STATE_FAILED) {
-			pr_debug("Moving to"
-					" TARG_SESS_STATE_LOGGED_IN.\n");
+			target_debug("Moving to"
+				     " TARG_SESS_STATE_LOGGED_IN.\n");
 			sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 			stop_timer = 1;
 		}
 
-		pr_debug("iSCSI Login successful on CID: %hu from %pISpc to"
-			" %pISpc,%hu\n", conn->cid, &conn->login_sockaddr,
-			&conn->local_sockaddr, tpg->tpgt);
+		target_debug("iSCSI Login successful on CID: %hu from %pISpc to"
+			     " %pISpc,%hu\n",
+			     conn->cid, &conn->login_sockaddr, &conn->local_sockaddr, tpg->tpgt);
 
 		list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 		atomic_inc(&sess->nconn);
-		pr_debug("Incremented iSCSI Connection count to %d"
-			" from node: %s\n", atomic_read(&sess->nconn),
-			sess->sess_ops->InitiatorName);
+		target_debug("Incremented iSCSI Connection count to %d"
+			     " from node: %s\n",
+			     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
 
 		iscsi_post_login_start_timers(conn);
@@ -766,33 +767,32 @@ void iscsi_post_login_handler(
 	spin_lock_bh(&se_tpg->session_lock);
 	__transport_register_session(&sess->tpg->tpg_se_tpg,
 			se_sess->se_node_acl, se_sess, sess);
-	pr_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
+	target_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 
-	pr_debug("iSCSI Login successful on CID: %hu from %pISpc to %pISpc,%hu\n",
-		conn->cid, &conn->login_sockaddr, &conn->local_sockaddr,
-		tpg->tpgt);
+	target_debug("iSCSI Login successful on CID: %hu from %pISpc to %pISpc,%hu\n", conn->cid,
+		     &conn->login_sockaddr, &conn->local_sockaddr, tpg->tpgt);
 
 	spin_lock_bh(&sess->conn_lock);
 	list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 	atomic_inc(&sess->nconn);
-	pr_debug("Incremented iSCSI Connection count to %d from node:"
-		" %s\n", atomic_read(&sess->nconn),
-		sess->sess_ops->InitiatorName);
+	target_debug("Incremented iSCSI Connection count to %d from node:"
+		     " %s\n",
+		     atomic_read(&sess->nconn), sess->sess_ops->InitiatorName);
 	spin_unlock_bh(&sess->conn_lock);
 
 	sess->sid = tpg->sid++;
 	if (!sess->sid)
 		sess->sid = tpg->sid++;
-	pr_debug("Established iSCSI session from node: %s\n",
-			sess->sess_ops->InitiatorName);
+	target_debug("Established iSCSI session from node: %s\n", sess->sess_ops->InitiatorName);
 
 	tpg->nsessions++;
 	if (tpg->tpg_tiqn)
 		tpg->tpg_tiqn->tiqn_nsessions++;
 
-	pr_debug("Incremented number of active iSCSI sessions to %u on"
-		" iSCSI Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt);
+	target_debug("Incremented number of active iSCSI sessions to %u on"
+		     " iSCSI Target Portal Group: %hu\n",
+		     tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
 	iscsi_post_login_start_timers(conn);
@@ -832,15 +832,14 @@ int iscsit_setup_np(
 		np->np_sock_type = SOCK_SEQPACKET;
 		break;
 	default:
-		pr_err("Unsupported network_transport: %d\n",
-				np->np_network_transport);
+		target_err("Unsupported network_transport: %d\n", np->np_network_transport);
 		return -EINVAL;
 	}
 
 	ret = sock_create(sockaddr->ss_family, np->np_sock_type,
 			np->np_ip_proto, &sock);
 	if (ret < 0) {
-		pr_err("sock_create() failed.\n");
+		target_err("sock_create() failed.\n");
 		return ret;
 	}
 	np->np_socket = sock;
@@ -865,13 +864,13 @@ int iscsit_setup_np(
 
 	ret = kernel_bind(sock, (struct sockaddr *)&np->np_sockaddr, len);
 	if (ret < 0) {
-		pr_err("kernel_bind() failed: %d\n", ret);
+		target_err("kernel_bind() failed: %d\n", ret);
 		goto fail;
 	}
 
 	ret = kernel_listen(sock, backlog);
 	if (ret != 0) {
-		pr_err("kernel_listen() failed: %d\n", ret);
+		target_err("kernel_listen() failed: %d\n", ret);
 		goto fail;
 	}
 
@@ -977,10 +976,10 @@ int iscsit_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
 	payload_length	= ntoh24(login_req->dlength);
 	padding = ((-payload_length) & 3);
 
-	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
-		login_req->flags, login_req->itt, login_req->cmdsn,
-		login_req->exp_statsn, login_req->cid, payload_length);
+	target_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		     " CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+		     login_req->flags, login_req->itt, login_req->cmdsn, login_req->exp_statsn,
+		     login_req->cid, payload_length);
 	/*
 	 * Setup the initial iscsi_login values from the leading
 	 * login request PDU.
@@ -1031,7 +1030,7 @@ iscsit_conn_set_transport(struct iscsit_conn *conn, struct iscsit_transport *t)
 
 	rc = try_module_get(t->owner);
 	if (!rc) {
-		pr_err("try_module_get() failed for %s\n", t->name);
+		target_err("try_module_get() failed for %s\n", t->name);
 		return -EINVAL;
 	}
 
@@ -1045,10 +1044,10 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 	conn = kzalloc(sizeof(struct iscsit_conn), GFP_KERNEL);
 	if (!conn) {
-		pr_err("Could not allocate memory for new connection\n");
+		target_err("Could not allocate memory for new connection\n");
 		return NULL;
 	}
-	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
+	target_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 
 	init_waitqueue_head(&conn->queues_wq);
@@ -1083,17 +1082,17 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
 	if (!conn->conn_ops) {
-		pr_err("Unable to allocate memory for struct iscsi_conn_ops.\n");
+		target_err("Unable to allocate memory for struct iscsi_conn_ops.\n");
 		goto put_transport;
 	}
 
 	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
-		pr_err("Unable to allocate conn->conn_cpumask\n");
+		target_err("Unable to allocate conn->conn_cpumask\n");
 		goto free_conn_ops;
 	}
 
 	if (!zalloc_cpumask_var(&conn->allowed_cpumask, GFP_KERNEL)) {
-		pr_err("Unable to allocate conn->allowed_cpumask\n");
+		target_err("Unable to allocate conn->allowed_cpumask\n");
 		goto free_conn_cpumask;
 	}
 
@@ -1132,7 +1131,7 @@ void iscsi_target_login_sess_out(struct iscsit_conn *conn,
 	if (!new_sess)
 		goto old_sess_out;
 
-	pr_err("iSCSI Login negotiation failed.\n");
+	target_err("iSCSI Login negotiation failed.\n");
 	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				   ISCSI_LOGIN_STATUS_INIT_ERR);
 	if (!zero_tsih || !conn->sess)
@@ -1256,7 +1255,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	iscsit_start_login_timer(conn, current);
 
-	pr_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
+	target_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
 	conn->conn_state = TARG_CONN_STATE_XPT_UP;
 	/*
 	 * This will process the first login request + payload..
@@ -1278,8 +1277,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
 		spin_unlock_bh(&np->np_thread_lock);
-		pr_err("iSCSI Network Portal on %pISpc currently not"
-			" active.\n", &np->np_sockaddr);
+		target_err("iSCSI Network Portal on %pISpc currently not"
+			   " active.\n",
+			   &np->np_sockaddr);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
 		goto new_sess_out;
@@ -1288,11 +1288,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	conn->network_transport = np->np_network_transport;
 
-	pr_debug("Received iSCSI login request from %pISpc on %s Network"
-		" Portal %pISpc\n", &conn->login_sockaddr, np->np_transport->name,
-		&conn->local_sockaddr);
+	target_debug("Received iSCSI login request from %pISpc on %s Network"
+		     " Portal %pISpc\n",
+		     &conn->login_sockaddr, np->np_transport->name, &conn->local_sockaddr);
 
-	pr_debug("Moving to TARG_CONN_STATE_IN_LOGIN.\n");
+	target_debug("Moving to TARG_CONN_STATE_IN_LOGIN.\n");
 	conn->conn_state	= TARG_CONN_STATE_IN_LOGIN;
 
 	if (iscsi_login_check_initiator_version(conn, pdu->max_version,
@@ -1341,7 +1341,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 
 	tpg = conn->tpg;
 	if (!tpg) {
-		pr_err("Unable to locate struct iscsit_conn->tpg\n");
+		target_err("Unable to locate struct iscsit_conn->tpg\n");
 		goto new_sess_out;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index fa3fb5f4e6bc..5e7f3baa13bb 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -88,8 +88,9 @@ int extract_param(
 		return -EINVAL;
 
 	if (len >= max_length) {
-		pr_err("Length of input: %d exceeds max_length:"
-			" %d\n", len, max_length);
+		target_err("Length of input: %d exceeds max_length:"
+			   " %d\n",
+			   len, max_length);
 		return -EINVAL;
 	}
 	memcpy(out_buf, ptr, len);
@@ -109,7 +110,7 @@ static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsit_conn *conn)
 
 	se_nacl = conn->sess->se_sess->se_node_acl;
 	if (!se_nacl) {
-		pr_err("Unable to locate struct se_node_acl for CHAP auth\n");
+		target_err("Unable to locate struct se_node_acl for CHAP auth\n");
 		return NULL;
 	}
 
@@ -171,8 +172,8 @@ int iscsi_target_check_login_request(
 	case ISCSI_OP_LOGIN:
 		break;
 	default:
-		pr_err("Received unknown opcode 0x%02x.\n",
-				login_req->opcode & ISCSI_OPCODE_MASK);
+		target_err("Received unknown opcode 0x%02x.\n",
+			   login_req->opcode & ISCSI_OPCODE_MASK);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
@@ -180,8 +181,8 @@ int iscsi_target_check_login_request(
 
 	if ((login_req->flags & ISCSI_FLAG_LOGIN_CONTINUE) &&
 	    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
-		pr_err("Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
-			" and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
+		target_err("Login request has both ISCSI_FLAG_LOGIN_CONTINUE"
+			   " and ISCSI_FLAG_LOGIN_TRANSIT set, protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
@@ -191,9 +192,9 @@ int iscsi_target_check_login_request(
 	req_nsg = ISCSI_LOGIN_NEXT_STAGE(login_req->flags);
 
 	if (req_csg != login->current_stage) {
-		pr_err("Initiator unexpectedly changed login stage"
-			" from %d to %d, login failed.\n", login->current_stage,
-			req_csg);
+		target_err("Initiator unexpectedly changed login stage"
+			   " from %d to %d, login failed.\n",
+			   login->current_stage, req_csg);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
@@ -202,9 +203,9 @@ int iscsi_target_check_login_request(
 	if ((req_nsg == 2) || (req_csg >= 2) ||
 	   ((login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT) &&
 	    (req_nsg <= req_csg))) {
-		pr_err("Illegal login_req->flags Combination, CSG: %d,"
-			" NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n", req_csg,
-			req_nsg, (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT));
+		target_err("Illegal login_req->flags Combination, CSG: %d,"
+			   " NSG: %d, ISCSI_FLAG_LOGIN_TRANSIT: %d.\n",
+			   req_csg, req_nsg, (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT));
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
@@ -212,34 +213,35 @@ int iscsi_target_check_login_request(
 
 	if ((login_req->max_version != login->version_max) ||
 	    (login_req->min_version != login->version_min)) {
-		pr_err("Login request changed Version Max/Nin"
-			" unexpectedly to 0x%02x/0x%02x, protocol error\n",
-			login_req->max_version, login_req->min_version);
+		target_err("Login request changed Version Max/Nin"
+			   " unexpectedly to 0x%02x/0x%02x, protocol error\n",
+			   login_req->max_version, login_req->min_version);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
 	}
 
 	if (memcmp(login_req->isid, login->isid, 6) != 0) {
-		pr_err("Login request changed ISID unexpectedly,"
-				" protocol error.\n");
+		target_err("Login request changed ISID unexpectedly,"
+			   " protocol error.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
 	}
 
 	if (login_req->itt != login->init_task_tag) {
-		pr_err("Login request changed ITT unexpectedly to"
-			" 0x%08x, protocol error.\n", login_req->itt);
+		target_err("Login request changed ITT unexpectedly to"
+			   " 0x%08x, protocol error.\n",
+			   login_req->itt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_INIT_ERR);
 		return -1;
 	}
 
 	if (payload_length > MAX_KEY_VALUE_PAIRS) {
-		pr_err("Login request payload exceeds default"
-			" MaxRecvDataSegmentLength: %u, protocol error.\n",
-				MAX_KEY_VALUE_PAIRS);
+		target_err("Login request payload exceeds default"
+			   " MaxRecvDataSegmentLength: %u, protocol error.\n",
+			   MAX_KEY_VALUE_PAIRS);
 		return -1;
 	}
 
@@ -259,8 +261,8 @@ static int iscsi_target_check_first_request(
 	list_for_each_entry(param, &conn->param_list->param_list, p_list) {
 		if (!strncmp(param->name, SESSIONTYPE, 11)) {
 			if (!IS_PSTATE_ACCEPTOR(param)) {
-				pr_err("SessionType key not received"
-					" in first login request.\n");
+				target_err("SessionType key not received"
+					   " in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 				return -1;
@@ -274,8 +276,8 @@ static int iscsi_target_check_first_request(
 				if (!login->leading_connection)
 					continue;
 
-				pr_err("InitiatorName key not received"
-					" in first login request.\n");
+				target_err("InitiatorName key not received"
+					   " in first login request.\n");
 				iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 				return -1;
@@ -289,8 +291,8 @@ static int iscsi_target_check_first_request(
 			if (!login->leading_connection) {
 				se_nacl = conn->sess->se_sess->se_node_acl;
 				if (!se_nacl) {
-					pr_err("Unable to locate"
-						" struct se_node_acl\n");
+					target_err("Unable to locate"
+						   " struct se_node_acl\n");
 					iscsit_tx_login_rsp(conn,
 							ISCSI_STATUS_CLS_INITIATOR_ERR,
 							ISCSI_LOGIN_STATUS_TGT_NOT_FOUND);
@@ -299,10 +301,10 @@ static int iscsi_target_check_first_request(
 
 				if (strcmp(param->value,
 						se_nacl->initiatorname)) {
-					pr_err("Incorrect"
-						" InitiatorName: %s for this"
-						" iSCSI Initiator Node.\n",
-						param->value);
+					target_err("Incorrect"
+						   " InitiatorName: %s for this"
+						   " iSCSI Initiator Node.\n",
+						   param->value);
 					iscsit_tx_login_rsp(conn,
 							ISCSI_STATUS_CLS_INITIATOR_ERR,
 							ISCSI_LOGIN_STATUS_TGT_NOT_FOUND);
@@ -331,11 +333,11 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	login_rsp->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
 	login_rsp->max_cmdsn		= cpu_to_be32((u32) atomic_read(&conn->sess->max_cmd_sn));
 
-	pr_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
-		" ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
-		" %u\n", login_rsp->flags, (__force u32)login_rsp->itt,
-		ntohl(login_rsp->exp_cmdsn), ntohl(login_rsp->max_cmdsn),
-		ntohl(login_rsp->statsn), login->rsp_length);
+	target_debug("Sending Login Response, Flags: 0x%02x, ITT: 0x%08x,"
+		     " ExpCmdSN; 0x%08x, MaxCmdSN: 0x%08x, StatSN: 0x%08x, Length:"
+		     " %u\n",
+		     login_rsp->flags, (__force u32)login_rsp->itt, ntohl(login_rsp->exp_cmdsn),
+		     ntohl(login_rsp->max_cmdsn), ntohl(login_rsp->statsn), login->rsp_length);
 
 	padding = ((-login->rsp_length) & 3);
 	/*
@@ -386,7 +388,7 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 	bool rc;
 
 	trace_sk_data_ready(sk);
-	pr_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
+	target_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (!sk->sk_user_data) {
@@ -395,17 +397,17 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 	}
 	if (!test_bit(LOGIN_FLAGS_READY, &conn->login_flags)) {
 		write_unlock_bh(&sk->sk_callback_lock);
-		pr_debug("Got LOGIN_FLAGS_READY=0, conn: %p >>>>\n", conn);
+		target_debug("Got LOGIN_FLAGS_READY=0, conn: %p >>>>\n", conn);
 		return;
 	}
 	if (test_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags)) {
 		write_unlock_bh(&sk->sk_callback_lock);
-		pr_debug("Got LOGIN_FLAGS_CLOSED=1, conn: %p >>>>\n", conn);
+		target_debug("Got LOGIN_FLAGS_CLOSED=1, conn: %p >>>>\n", conn);
 		return;
 	}
 	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
 		write_unlock_bh(&sk->sk_callback_lock);
-		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
+		target_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
 		if (iscsi_target_sk_data_ready == conn->orig_data_ready)
 			return;
 		conn->orig_data_ready(sk);
@@ -414,8 +416,8 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 
 	rc = schedule_delayed_work(&conn->login_work, 0);
 	if (!rc) {
-		pr_debug("iscsi_target_sk_data_ready, schedule_delayed_work"
-			 " got false\n");
+		target_debug("iscsi_target_sk_data_ready, schedule_delayed_work"
+			     " got false\n");
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 }
@@ -430,7 +432,7 @@ static void iscsi_target_set_sock_callbacks(struct iscsit_conn *conn)
 		return;
 
 	sk = conn->sock->sk;
-	pr_debug("Entering iscsi_target_set_sock_callbacks: conn: %p\n", conn);
+	target_debug("Entering iscsi_target_set_sock_callbacks: conn: %p\n", conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data = conn;
@@ -452,7 +454,7 @@ static void iscsi_target_restore_sock_callbacks(struct iscsit_conn *conn)
 		return;
 
 	sk = conn->sock->sk;
-	pr_debug("Entering iscsi_target_restore_sock_callbacks: conn: %p\n", conn);
+	target_debug("Entering iscsi_target_restore_sock_callbacks: conn: %p\n", conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (!sk->sk_user_data) {
@@ -473,8 +475,8 @@ static int iscsi_target_do_login(struct iscsit_conn *, struct iscsi_login *);
 static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
 	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
-		pr_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
-			"returning TRUE\n");
+		target_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
+			     "returning TRUE\n");
 		return true;
 	}
 	return false;
@@ -546,8 +548,8 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	int rc, zero_tsih = login->zero_tsih;
 	bool state;
 
-	pr_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n",
-			conn, current->comm, current->pid);
+	target_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n", conn, current->comm,
+		     current->pid);
 
 	spin_lock(&conn->login_worker_lock);
 	set_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags);
@@ -572,12 +574,12 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (!state) {
-		pr_debug("iscsi_target_do_login_rx: tpg_state != TPG_STATE_ACTIVE\n");
+		target_debug("iscsi_target_do_login_rx: tpg_state != TPG_STATE_ACTIVE\n");
 		goto err;
 	}
 
 	if (iscsi_target_sk_check_close(conn)) {
-		pr_debug("iscsi_target_do_login_rx, TCP state CLOSE\n");
+		target_debug("iscsi_target_do_login_rx, TCP state CLOSE\n");
 		goto err;
 	}
 
@@ -585,7 +587,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	rc = iscsit_set_login_timer_kworker(conn, current);
 	if (rc < 0) {
 		/* The login timer has already expired */
-		pr_debug("iscsi_target_do_login_rx, login failed\n");
+		target_debug("iscsi_target_do_login_rx, login failed\n");
 		goto err;
 	}
 
@@ -595,8 +597,8 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0)
 		goto err;
 
-	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
-			conn, current->comm, current->pid);
+	target_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n", conn, current->comm,
+		     current->pid);
 
 	/*
 	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
@@ -659,7 +661,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	void (*orig_state_change)(struct sock *);
 	bool state;
 
-	pr_debug("Entering iscsi_target_sk_state_change\n");
+	target_debug("Entering iscsi_target_sk_state_change\n");
 
 	write_lock_bh(&sk->sk_callback_lock);
 	conn = sk->sk_user_data;
@@ -670,19 +672,19 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	orig_state_change = conn->orig_state_change;
 
 	if (!test_bit(LOGIN_FLAGS_READY, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_READY=0 sk_state_change conn: %p\n",
-			 conn);
+		target_debug("Got LOGIN_FLAGS_READY=0 sk_state_change conn: %p\n", conn);
 		write_unlock_bh(&sk->sk_callback_lock);
 		orig_state_change(sk);
 		return;
 	}
 	state = __iscsi_target_sk_check_close(sk);
-	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
+	target_debug("__iscsi_target_sk_close_change: state: %d\n", state);
 
 	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
 	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
-			 " sk_state_change conn: %p\n", conn);
+		target_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
+			     " sk_state_change conn: %p\n",
+			     conn);
 		if (state)
 			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
@@ -690,8 +692,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 		return;
 	}
 	if (test_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_CLOSED=1 sk_state_change conn: %p\n",
-			 conn);
+		target_debug("Got LOGIN_FLAGS_CLOSED=1 sk_state_change conn: %p\n", conn);
 		write_unlock_bh(&sk->sk_callback_lock);
 		orig_state_change(sk);
 		return;
@@ -712,7 +713,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	 * the remaining iscsi connection resources.
 	 */
 	if (state) {
-		pr_debug("iscsi_target_sk_state_change got failed state\n");
+		target_debug("iscsi_target_sk_state_change got failed state\n");
 		set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		state = test_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
@@ -776,12 +777,12 @@ static int iscsi_target_do_authentication(
 			param->value);
 	switch (authret) {
 	case 0:
-		pr_debug("Received OK response"
-		" from LIO Authentication, continuing.\n");
+		target_debug("Received OK response"
+			     " from LIO Authentication, continuing.\n");
 		break;
 	case 1:
-		pr_debug("iSCSI security negotiation"
-			" completed successfully.\n");
+		target_debug("iSCSI security negotiation"
+			     " completed successfully.\n");
 		login->auth_complete = 1;
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
@@ -792,14 +793,15 @@ static int iscsi_target_do_authentication(
 		return iscsi_target_check_for_existing_instances(
 				conn, login);
 	case 2:
-		pr_err("Security negotiation"
-			" failed.\n");
+		target_err("Security negotiation"
+			   " failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
 	default:
-		pr_err("Received unknown error %d from LIO"
-				" Authentication\n", authret);
+		target_err("Received unknown error %d from LIO"
+			   " Authentication\n",
+			   authret);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_TARGET_ERROR);
 		return -1;
@@ -824,18 +826,16 @@ bool iscsi_conn_auth_required(struct iscsit_conn *conn)
 	 */
 	se_nacl = conn->sess->se_sess->se_node_acl;
 	if (!se_nacl) {
-		pr_debug("Unknown ACL is trying to connect\n");
+		target_debug("Unknown ACL is trying to connect\n");
 		return true;
 	}
 
 	if (se_nacl->dynamic_node_acl) {
-		pr_debug("Dynamic ACL %s is trying to connect\n",
-			 se_nacl->initiatorname);
+		target_debug("Dynamic ACL %s is trying to connect\n", se_nacl->initiatorname);
 		return conn->tpg->tpg_attrib.authentication;
 	}
 
-	pr_debug("Known ACL %s is trying to connect\n",
-		 se_nacl->initiatorname);
+	target_debug("Known ACL %s is trying to connect\n", se_nacl->initiatorname);
 
 	nacl = to_iscsi_nacl(se_nacl);
 	if (nacl->node_attrib.authentication == NA_AUTHENTICATION_INHERITED)
@@ -873,9 +873,10 @@ static int iscsi_target_handle_csg_zero(
 
 	if (ret > 0) {
 		if (login->auth_complete) {
-			pr_err("Initiator has already been"
-				" successfully authenticated, but is still"
-				" sending %s keys.\n", param->value);
+			target_err("Initiator has already been"
+				   " successfully authenticated, but is still"
+				   " sending %s keys.\n",
+				   param->value);
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 					ISCSI_LOGIN_STATUS_INIT_ERR);
 			return -1;
@@ -883,8 +884,8 @@ static int iscsi_target_handle_csg_zero(
 
 		goto do_auth;
 	} else if (!payload_length) {
-		pr_err("Initiator sent zero length security payload,"
-		       " login failed\n");
+		target_err("Initiator sent zero length security payload,"
+			   " login failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				    ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
@@ -909,9 +910,9 @@ static int iscsi_target_handle_csg_zero(
 
 		if (auth_required) {
 			if (!strncmp(param->value, NONE, 4)) {
-				pr_err("Initiator sent AuthMethod=None but"
-				       " Target is enforcing iSCSI Authentication,"
-				       " login failed.\n");
+				target_err("Initiator sent AuthMethod=None but"
+					   " Target is enforcing iSCSI Authentication,"
+					   " login failed.\n");
 				iscsit_tx_login_rsp(conn,
 						ISCSI_STATUS_CLS_INITIATOR_ERR,
 						ISCSI_LOGIN_STATUS_AUTH_FAILED);
@@ -995,9 +996,9 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 	}
 
 	if (!iscsi_conn_authenticated(conn, login)) {
-		pr_err("Initiator is requesting CSG: 1, has not been"
-		       " successfully authenticated, and the Target is"
-		       " enforcing iSCSI Authentication, login failed.\n");
+		target_err("Initiator is requesting CSG: 1, has not been"
+			   " successfully authenticated, and the Target is"
+			   " enforcing iSCSI Authentication, login failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
@@ -1030,7 +1031,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 
 	while (1) {
 		if (++pdu_count > MAX_LOGIN_PDUS) {
-			pr_err("MAX_LOGIN_PDUS count reached.\n");
+			target_err("MAX_LOGIN_PDUS count reached.\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
 			return -1;
@@ -1066,9 +1067,9 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 			}
 			break;
 		default:
-			pr_err("Illegal CSG: %d received from"
-				" Initiator, protocol error.\n",
-				ISCSI_LOGIN_CURRENT_STAGE(login_req->flags));
+			target_err("Illegal CSG: %d received from"
+				   " Initiator, protocol error.\n",
+				   ISCSI_LOGIN_CURRENT_STAGE(login_req->flags));
 			break;
 		}
 
@@ -1129,7 +1130,7 @@ int iscsi_target_locate_portal(
 
 	tmpbuf = kmemdup_nul(login->req_buf, payload_length, GFP_KERNEL);
 	if (!tmpbuf) {
-		pr_err("Unable to allocate memory for tmpbuf.\n");
+		target_err("Unable to allocate memory for tmpbuf.\n");
 		return -1;
 	}
 
@@ -1159,8 +1160,8 @@ int iscsi_target_locate_portal(
 	 * See 5.3.  Login Phase.
 	 */
 	if (!i_buf) {
-		pr_err("InitiatorName key not received"
-			" in first login request.\n");
+		target_err("InitiatorName key not received"
+			   " in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1177,8 +1178,8 @@ int iscsi_target_locate_portal(
 		if (!login->leading_connection)
 			goto get_target;
 
-		pr_err("SessionType key not received"
-			" in first login request.\n");
+		target_err("SessionType key not received"
+			   " in first login request.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1198,7 +1199,7 @@ int iscsi_target_locate_portal(
 		 * Setup crc32c modules from libcrypto
 		 */
 		if (iscsi_login_setup_crypto(conn) < 0) {
-			pr_err("iscsi_login_setup_crypto() failed\n");
+			target_err("iscsi_login_setup_crypto() failed\n");
 			ret = -1;
 			goto out;
 		}
@@ -1220,9 +1221,9 @@ int iscsi_target_locate_portal(
 
 get_target:
 	if (!t_buf) {
-		pr_err("TargetName key not received"
-			" in first login request while"
-			" SessionType=Normal.\n");
+		target_err("TargetName key not received"
+			   " in first login request while"
+			   " SessionType=Normal.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 			ISCSI_LOGIN_STATUS_MISSING_FIELDS);
 		ret = -1;
@@ -1234,22 +1235,24 @@ int iscsi_target_locate_portal(
 	 */
 	tiqn = iscsit_get_tiqn_for_login(t_buf);
 	if (!tiqn) {
-		pr_err("Unable to locate Target IQN: %s in"
-			" Storage Node\n", t_buf);
+		target_err("Unable to locate Target IQN: %s in"
+			   " Storage Node\n",
+			   t_buf);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
 		ret = -1;
 		goto out;
 	}
-	pr_debug("Located Storage Object: %s\n", tiqn->tiqn);
+	target_debug("Located Storage Object: %s\n", tiqn->tiqn);
 
 	/*
 	 * Locate Target Portal Group from Storage Node.
 	 */
 	conn->tpg = iscsit_get_tpg_from_np(tiqn, np, &tpg_np);
 	if (!conn->tpg) {
-		pr_err("Unable to locate Target Portal Group"
-				" on %s\n", tiqn->tiqn);
+		target_err("Unable to locate Target Portal Group"
+			   " on %s\n",
+			   tiqn->tiqn);
 		iscsit_put_tiqn_for_login(tiqn);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
@@ -1257,12 +1260,12 @@ int iscsi_target_locate_portal(
 		goto out;
 	}
 	conn->tpg_np = tpg_np;
-	pr_debug("Located Portal Group Object: %hu\n", conn->tpg->tpgt);
+	target_debug("Located Portal Group Object: %hu\n", conn->tpg->tpgt);
 	/*
 	 * Setup crc32c modules from libcrypto
 	 */
 	if (iscsi_login_setup_crypto(conn) < 0) {
-		pr_err("iscsi_login_setup_crypto() failed\n");
+		target_err("iscsi_login_setup_crypto() failed\n");
 		kref_put(&tpg_np->tpg_np_kref, iscsit_login_kref_put);
 		iscsit_put_tiqn_for_login(tiqn);
 		conn->tpg = NULL;
@@ -1304,9 +1307,9 @@ int iscsi_target_locate_portal(
 	sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
 			&conn->tpg->tpg_se_tpg, i_buf);
 	if (!sess->se_sess->se_node_acl) {
-		pr_err("iSCSI Initiator Node: %s is not authorized to"
-			" access iSCSI target portal group: %hu.\n",
-				i_buf, conn->tpg->tpgt);
+		target_err("iSCSI Initiator Node: %s is not authorized to"
+			   " access iSCSI target portal group: %hu.\n",
+			   i_buf, conn->tpg->tpgt);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_TGT_FORBIDDEN);
 		ret = -1;
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index d63efdefb18e..5b1269fe9184 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -48,20 +48,21 @@ int iscsit_na_dataout_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout > NA_DATAOUT_TIMEOUT_MAX) {
-		pr_err("Requested DataOut Timeout %u larger than"
-			" maximum %u\n", dataout_timeout,
-			NA_DATAOUT_TIMEOUT_MAX);
+		target_err("Requested DataOut Timeout %u larger than"
+			   " maximum %u\n",
+			   dataout_timeout, NA_DATAOUT_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout < NA_DATAOUT_TIMEOUT_MIX) {
-		pr_err("Requested DataOut Timeout %u smaller than"
-			" minimum %u\n", dataout_timeout,
-			NA_DATAOUT_TIMEOUT_MIX);
+		target_err("Requested DataOut Timeout %u smaller than"
+			   " minimum %u\n",
+			   dataout_timeout, NA_DATAOUT_TIMEOUT_MIX);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout = dataout_timeout;
-	pr_debug("Set DataOut Timeout to %u for Initiator Node"
-		" %s\n", a->dataout_timeout, iscsit_na_get_initiatorname(acl));
+	target_debug("Set DataOut Timeout to %u for Initiator Node"
+		     " %s\n",
+		     a->dataout_timeout, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -73,21 +74,21 @@ int iscsit_na_dataout_timeout_retries(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (dataout_timeout_retries > NA_DATAOUT_TIMEOUT_RETRIES_MAX) {
-		pr_err("Requested DataOut Timeout Retries %u larger"
-			" than maximum %u", dataout_timeout_retries,
-				NA_DATAOUT_TIMEOUT_RETRIES_MAX);
+		target_err("Requested DataOut Timeout Retries %u larger"
+			   " than maximum %u",
+			   dataout_timeout_retries, NA_DATAOUT_TIMEOUT_RETRIES_MAX);
 		return -EINVAL;
 	} else if (dataout_timeout_retries < NA_DATAOUT_TIMEOUT_RETRIES_MIN) {
-		pr_err("Requested DataOut Timeout Retries %u smaller"
-			" than minimum %u", dataout_timeout_retries,
-				NA_DATAOUT_TIMEOUT_RETRIES_MIN);
+		target_err("Requested DataOut Timeout Retries %u smaller"
+			   " than minimum %u",
+			   dataout_timeout_retries, NA_DATAOUT_TIMEOUT_RETRIES_MIN);
 		return -EINVAL;
 	}
 
 	a->dataout_timeout_retries = dataout_timeout_retries;
-	pr_debug("Set DataOut Timeout Retries to %u for"
-		" Initiator Node %s\n", a->dataout_timeout_retries,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set DataOut Timeout Retries to %u for"
+		     " Initiator Node %s\n",
+		     a->dataout_timeout_retries, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -104,21 +105,22 @@ int iscsit_na_nopin_timeout(
 	u32 orig_nopin_timeout = a->nopin_timeout;
 
 	if (nopin_timeout > NA_NOPIN_TIMEOUT_MAX) {
-		pr_err("Requested NopIn Timeout %u larger than maximum"
-			" %u\n", nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
+		target_err("Requested NopIn Timeout %u larger than maximum"
+			   " %u\n",
+			   nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if ((nopin_timeout < NA_NOPIN_TIMEOUT_MIN) &&
 		   (nopin_timeout != 0)) {
-		pr_err("Requested NopIn Timeout %u smaller than"
-			" minimum %u and not 0\n", nopin_timeout,
-			NA_NOPIN_TIMEOUT_MIN);
+		target_err("Requested NopIn Timeout %u smaller than"
+			   " minimum %u and not 0\n",
+			   nopin_timeout, NA_NOPIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_timeout = nopin_timeout;
-	pr_debug("Set NopIn Timeout to %u for Initiator"
-		" Node %s\n", a->nopin_timeout,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set NopIn Timeout to %u for Initiator"
+		     " Node %s\n",
+		     a->nopin_timeout, iscsit_na_get_initiatorname(acl));
 	/*
 	 * Reenable disabled nopin_timeout timer for all iSCSI connections.
 	 */
@@ -154,21 +156,21 @@ int iscsit_na_nopin_response_timeout(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (nopin_response_timeout > NA_NOPIN_RESPONSE_TIMEOUT_MAX) {
-		pr_err("Requested NopIn Response Timeout %u larger"
-			" than maximum %u\n", nopin_response_timeout,
-				NA_NOPIN_RESPONSE_TIMEOUT_MAX);
+		target_err("Requested NopIn Response Timeout %u larger"
+			   " than maximum %u\n",
+			   nopin_response_timeout, NA_NOPIN_RESPONSE_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (nopin_response_timeout < NA_NOPIN_RESPONSE_TIMEOUT_MIN) {
-		pr_err("Requested NopIn Response Timeout %u smaller"
-			" than minimum %u\n", nopin_response_timeout,
-				NA_NOPIN_RESPONSE_TIMEOUT_MIN);
+		target_err("Requested NopIn Response Timeout %u smaller"
+			   " than minimum %u\n",
+			   nopin_response_timeout, NA_NOPIN_RESPONSE_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->nopin_response_timeout = nopin_response_timeout;
-	pr_debug("Set NopIn Response Timeout to %u for"
-		" Initiator Node %s\n", a->nopin_timeout,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set NopIn Response Timeout to %u for"
+		     " Initiator Node %s\n",
+		     a->nopin_timeout, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -180,15 +182,16 @@ int iscsit_na_random_datain_pdu_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_pdu_offsets != 0 && random_datain_pdu_offsets != 1) {
-		pr_err("Requested Random DataIN PDU Offsets: %u not"
-			" 0 or 1\n", random_datain_pdu_offsets);
+		target_err("Requested Random DataIN PDU Offsets: %u not"
+			   " 0 or 1\n",
+			   random_datain_pdu_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_pdu_offsets = random_datain_pdu_offsets;
-	pr_debug("Set Random DataIN PDU Offsets to %u for"
-		" Initiator Node %s\n", a->random_datain_pdu_offsets,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set Random DataIN PDU Offsets to %u for"
+		     " Initiator Node %s\n",
+		     a->random_datain_pdu_offsets, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -200,15 +203,16 @@ int iscsit_na_random_datain_seq_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_datain_seq_offsets != 0 && random_datain_seq_offsets != 1) {
-		pr_err("Requested Random DataIN Sequence Offsets: %u"
-			" not 0 or 1\n", random_datain_seq_offsets);
+		target_err("Requested Random DataIN Sequence Offsets: %u"
+			   " not 0 or 1\n",
+			   random_datain_seq_offsets);
 		return -EINVAL;
 	}
 
 	a->random_datain_seq_offsets = random_datain_seq_offsets;
-	pr_debug("Set Random DataIN Sequence Offsets to %u for"
-		" Initiator Node %s\n", a->random_datain_seq_offsets,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set Random DataIN Sequence Offsets to %u for"
+		     " Initiator Node %s\n",
+		     a->random_datain_seq_offsets, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -220,15 +224,16 @@ int iscsit_na_random_r2t_offsets(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (random_r2t_offsets != 0 && random_r2t_offsets != 1) {
-		pr_err("Requested Random R2T Offsets: %u not"
-			" 0 or 1\n", random_r2t_offsets);
+		target_err("Requested Random R2T Offsets: %u not"
+			   " 0 or 1\n",
+			   random_r2t_offsets);
 		return -EINVAL;
 	}
 
 	a->random_r2t_offsets = random_r2t_offsets;
-	pr_debug("Set Random R2T Offsets to %u for"
-		" Initiator Node %s\n", a->random_r2t_offsets,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set Random R2T Offsets to %u for"
+		     " Initiator Node %s\n",
+		     a->random_r2t_offsets, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
@@ -240,15 +245,14 @@ int iscsit_na_default_erl(
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
 	if (default_erl != 0 && default_erl != 1 && default_erl != 2) {
-		pr_err("Requested default ERL: %u not 0, 1, or 2\n",
-				default_erl);
+		target_err("Requested default ERL: %u not 0, 1, or 2\n", default_erl);
 		return -EINVAL;
 	}
 
 	a->default_erl = default_erl;
-	pr_debug("Set use ERL0 flag to %u for Initiator"
-		" Node %s\n", a->default_erl,
-		iscsit_na_get_initiatorname(acl));
+	target_debug("Set use ERL0 flag to %u for Initiator"
+		     " Node %s\n",
+		     a->default_erl, iscsit_na_get_initiatorname(acl));
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 5b90c22ee3dc..a195b45cb28a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -28,8 +28,7 @@ int iscsi_login_rx_data(
 
 	rx_got = rx_data(conn, &iov, 1, length);
 	if (rx_got != length) {
-		pr_err("rx_data returned %d, expecting %d.\n",
-				rx_got, length);
+		target_err("rx_data returned %d, expecting %d.\n", rx_got, length);
 		return -1;
 	}
 
@@ -59,8 +58,7 @@ int iscsi_login_tx_data(
 
 	tx_sent = tx_data(conn, &iov[0], iov_cnt, length);
 	if (tx_sent != length) {
-		pr_err("tx_data returned %d, expecting %d.\n",
-				tx_sent, length);
+		target_err("tx_data returned %d, expecting %d.\n", tx_sent, length);
 		return -1;
 	}
 
@@ -69,42 +67,30 @@ int iscsi_login_tx_data(
 
 void iscsi_dump_conn_ops(struct iscsi_conn_ops *conn_ops)
 {
-	pr_debug("HeaderDigest: %s\n", (conn_ops->HeaderDigest) ?
-				"CRC32C" : "None");
-	pr_debug("DataDigest: %s\n", (conn_ops->DataDigest) ?
-				"CRC32C" : "None");
-	pr_debug("MaxRecvDataSegmentLength: %u\n",
-				conn_ops->MaxRecvDataSegmentLength);
+	target_debug("HeaderDigest: %s\n", (conn_ops->HeaderDigest) ? "CRC32C" : "None");
+	target_debug("DataDigest: %s\n", (conn_ops->DataDigest) ? "CRC32C" : "None");
+	target_debug("MaxRecvDataSegmentLength: %u\n", conn_ops->MaxRecvDataSegmentLength);
 }
 
 void iscsi_dump_sess_ops(struct iscsi_sess_ops *sess_ops)
 {
-	pr_debug("InitiatorName: %s\n", sess_ops->InitiatorName);
-	pr_debug("InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
-	pr_debug("TargetName: %s\n", sess_ops->TargetName);
-	pr_debug("TargetAlias: %s\n", sess_ops->TargetAlias);
-	pr_debug("TargetPortalGroupTag: %hu\n",
-			sess_ops->TargetPortalGroupTag);
-	pr_debug("MaxConnections: %hu\n", sess_ops->MaxConnections);
-	pr_debug("InitialR2T: %s\n",
-			(sess_ops->InitialR2T) ? "Yes" : "No");
-	pr_debug("ImmediateData: %s\n", (sess_ops->ImmediateData) ?
-			"Yes" : "No");
-	pr_debug("MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
-	pr_debug("FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
-	pr_debug("DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
-	pr_debug("DefaultTime2Retain: %hu\n",
-			sess_ops->DefaultTime2Retain);
-	pr_debug("MaxOutstandingR2T: %hu\n",
-			sess_ops->MaxOutstandingR2T);
-	pr_debug("DataPDUInOrder: %s\n",
-			(sess_ops->DataPDUInOrder) ? "Yes" : "No");
-	pr_debug("DataSequenceInOrder: %s\n",
-			(sess_ops->DataSequenceInOrder) ? "Yes" : "No");
-	pr_debug("ErrorRecoveryLevel: %hu\n",
-			sess_ops->ErrorRecoveryLevel);
-	pr_debug("SessionType: %s\n", (sess_ops->SessionType) ?
-			"Discovery" : "Normal");
+	target_debug("InitiatorName: %s\n", sess_ops->InitiatorName);
+	target_debug("InitiatorAlias: %s\n", sess_ops->InitiatorAlias);
+	target_debug("TargetName: %s\n", sess_ops->TargetName);
+	target_debug("TargetAlias: %s\n", sess_ops->TargetAlias);
+	target_debug("TargetPortalGroupTag: %hu\n", sess_ops->TargetPortalGroupTag);
+	target_debug("MaxConnections: %hu\n", sess_ops->MaxConnections);
+	target_debug("InitialR2T: %s\n", (sess_ops->InitialR2T) ? "Yes" : "No");
+	target_debug("ImmediateData: %s\n", (sess_ops->ImmediateData) ? "Yes" : "No");
+	target_debug("MaxBurstLength: %u\n", sess_ops->MaxBurstLength);
+	target_debug("FirstBurstLength: %u\n", sess_ops->FirstBurstLength);
+	target_debug("DefaultTime2Wait: %hu\n", sess_ops->DefaultTime2Wait);
+	target_debug("DefaultTime2Retain: %hu\n", sess_ops->DefaultTime2Retain);
+	target_debug("MaxOutstandingR2T: %hu\n", sess_ops->MaxOutstandingR2T);
+	target_debug("DataPDUInOrder: %s\n", (sess_ops->DataPDUInOrder) ? "Yes" : "No");
+	target_debug("DataSequenceInOrder: %s\n", (sess_ops->DataSequenceInOrder) ? "Yes" : "No");
+	target_debug("ErrorRecoveryLevel: %hu\n", sess_ops->ErrorRecoveryLevel);
+	target_debug("SessionType: %s\n", (sess_ops->SessionType) ? "Discovery" : "Normal");
 }
 
 void iscsi_print_params(struct iscsi_param_list *param_list)
@@ -112,7 +98,7 @@ void iscsi_print_params(struct iscsi_param_list *param_list)
 	struct iscsi_param *param;
 
 	list_for_each_entry(param, &param_list->param_list, p_list)
-		pr_debug("%s: %s\n", param->name, param->value);
+		target_debug("%s: %s\n", param->name, param->value);
 }
 
 static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *param_list,
@@ -123,20 +109,20 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 
 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 	if (!param) {
-		pr_err("Unable to allocate memory for parameter.\n");
+		target_err("Unable to allocate memory for parameter.\n");
 		goto out;
 	}
 	INIT_LIST_HEAD(&param->p_list);
 
 	param->name = kstrdup(name, GFP_KERNEL);
 	if (!param->name) {
-		pr_err("Unable to allocate memory for parameter name.\n");
+		target_err("Unable to allocate memory for parameter name.\n");
 		goto out;
 	}
 
 	param->value = kstrdup(value, GFP_KERNEL);
 	if (!param->value) {
-		pr_err("Unable to allocate memory for parameter value.\n");
+		target_err("Unable to allocate memory for parameter value.\n");
 		goto out;
 	}
 
@@ -173,8 +159,7 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 		param->type = TYPE_STRING;
 		break;
 	default:
-		pr_err("Unknown type_range 0x%02x\n",
-				param->type_range);
+		target_err("Unknown type_range 0x%02x\n", param->type_range);
 		goto out;
 	}
 	list_add_tail(&param->p_list, &param_list->param_list);
@@ -198,8 +183,8 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 
 	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!pl) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_param_list.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_param_list.\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&pl->param_list);
@@ -569,7 +554,7 @@ int iscsi_copy_param_list(
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list) {
-		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
+		target_err("Unable to allocate memory for struct iscsi_param_list.\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&param_list->param_list);
@@ -585,7 +570,7 @@ int iscsi_copy_param_list(
 
 		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 		if (!new_param) {
-			pr_err("Unable to allocate memory for struct iscsi_param.\n");
+			target_err("Unable to allocate memory for struct iscsi_param.\n");
 			goto err_out;
 		}
 
@@ -595,7 +580,7 @@ int iscsi_copy_param_list(
 			kfree(new_param->value);
 			kfree(new_param->name);
 			kfree(new_param);
-			pr_err("Unable to allocate memory for parameter name/value.\n");
+			target_err("Unable to allocate memory for parameter name/value.\n");
 			goto err_out;
 		}
 
@@ -613,7 +598,7 @@ int iscsi_copy_param_list(
 	if (!list_empty(&param_list->param_list)) {
 		*dst_param_list = param_list;
 	} else {
-		pr_err("No parameters allocated.\n");
+		target_err("No parameters allocated.\n");
 		goto err_out;
 	}
 
@@ -660,7 +645,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 	struct iscsi_param *param;
 
 	if (!key || !param_list) {
-		pr_err("Key or parameter list pointer is NULL.\n");
+		target_err("Key or parameter list pointer is NULL.\n");
 		return NULL;
 	}
 
@@ -669,7 +654,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 			return param;
 	}
 
-	pr_err("Unable to locate key \"%s\".\n", key);
+	target_err("Unable to locate key \"%s\".\n", key);
 	return NULL;
 }
 EXPORT_SYMBOL(iscsi_find_param_from_key);
@@ -678,8 +663,8 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
 	if (!*value) {
-		pr_err("Unable to locate \"=\" separator for key,"
-				" ignoring request.\n");
+		target_err("Unable to locate \"=\" separator for key,"
+			   " ignoring request.\n");
 		return -1;
 	}
 
@@ -696,12 +681,11 @@ int iscsi_update_param_value(struct iscsi_param *param, char *value)
 
 	param->value = kstrdup(value, GFP_KERNEL);
 	if (!param->value) {
-		pr_err("Unable to allocate memory for value.\n");
+		target_err("Unable to allocate memory for value.\n");
 		return -ENOMEM;
 	}
 
-	pr_debug("iSCSI Parameter updated to %s=%s\n",
-			param->name, param->value);
+	target_debug("iSCSI Parameter updated to %s=%s\n", param->name, param->value);
 	return 0;
 }
 
@@ -713,15 +697,16 @@ static int iscsi_add_notunderstood_response(
 	struct iscsi_extra_response *extra_response;
 
 	if (strlen(value) > VALUE_MAXLEN) {
-		pr_err("Value for notunderstood key \"%s\" exceeds %d,"
-			" protocol error.\n", key, VALUE_MAXLEN);
+		target_err("Value for notunderstood key \"%s\" exceeds %d,"
+			   " protocol error.\n",
+			   key, VALUE_MAXLEN);
 		return -1;
 	}
 
 	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
 	if (!extra_response) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_extra_response.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_extra_response.\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
@@ -798,8 +783,9 @@ static void iscsi_check_proposer_for_optional_reply(struct iscsi_param *param,
 static int iscsi_check_boolean_value(struct iscsi_param *param, char *value)
 {
 	if (strcmp(value, YES) && strcmp(value, NO)) {
-		pr_err("Illegal value for \"%s\", must be either"
-			" \"%s\" or \"%s\".\n", param->name, YES, NO);
+		target_err("Illegal value for \"%s\", must be either"
+			   " \"%s\" or \"%s\".\n",
+			   param->name, YES, NO);
 		return -1;
 	}
 
@@ -815,56 +801,63 @@ static int iscsi_check_numerical_value(struct iscsi_param *param, char *value_pt
 
 	if (IS_TYPERANGE_0_TO_2(param)) {
 		if ((value < 0) || (value > 2)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 0 and 2.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 0 and 2.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_0_TO_3600(param)) {
 		if ((value < 0) || (value > 3600)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 0 and 3600.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 0 and 3600.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_0_TO_32767(param)) {
 		if ((value < 0) || (value > 32767)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 0 and 32767.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 0 and 32767.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_0_TO_65535(param)) {
 		if ((value < 0) || (value > 65535)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 0 and 65535.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 0 and 65535.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_1_TO_65535(param)) {
 		if ((value < 1) || (value > 65535)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 1 and 65535.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 1 and 65535.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_2_TO_3600(param)) {
 		if ((value < 2) || (value > 3600)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 2 and 3600.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 2 and 3600.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
 	}
 	if (IS_TYPERANGE_512_TO_16777215(param)) {
 		if ((value < 512) || (value > 16777215)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" between 512 and 16777215.\n", param->name);
+			target_err("Illegal value for \"%s\", must be"
+				   " between 512 and 16777215.\n",
+				   param->name);
 			return -1;
 		}
 		return 0;
@@ -882,26 +875,26 @@ static int iscsi_check_string_or_list_value(struct iscsi_param *param, char *val
 		if (strcmp(value, KRB5) && strcmp(value, SPKM1) &&
 		    strcmp(value, SPKM2) && strcmp(value, SRP) &&
 		    strcmp(value, CHAP) && strcmp(value, NONE)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" \"%s\", \"%s\", \"%s\", \"%s\", \"%s\""
-				" or \"%s\".\n", param->name, KRB5,
-					SPKM1, SPKM2, SRP, CHAP, NONE);
+			target_err("Illegal value for \"%s\", must be"
+				   " \"%s\", \"%s\", \"%s\", \"%s\", \"%s\""
+				   " or \"%s\".\n",
+				   param->name, KRB5, SPKM1, SPKM2, SRP, CHAP, NONE);
 			return -1;
 		}
 	}
 	if (IS_TYPERANGE_DIGEST_PARAM(param)) {
 		if (strcmp(value, CRC32C) && strcmp(value, NONE)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" \"%s\" or \"%s\".\n", param->name,
-					CRC32C, NONE);
+			target_err("Illegal value for \"%s\", must be"
+				   " \"%s\" or \"%s\".\n",
+				   param->name, CRC32C, NONE);
 			return -1;
 		}
 	}
 	if (IS_TYPERANGE_SESSIONTYPE(param)) {
 		if (strcmp(value, DISCOVERY) && strcmp(value, NORMAL)) {
-			pr_err("Illegal value for \"%s\", must be"
-				" \"%s\" or \"%s\".\n", param->name,
-					DISCOVERY, NORMAL);
+			target_err("Illegal value for \"%s\", must be"
+				   " \"%s\" or \"%s\".\n",
+				   param->name, DISCOVERY, NORMAL);
 			return -1;
 		}
 	}
@@ -961,8 +954,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 	char *negotiated_value = NULL;
 
 	if (IS_PSTATE_ACCEPTOR(param)) {
-		pr_err("Received key \"%s\" twice, protocol error.\n",
-				param->name);
+		target_err("Received key \"%s\" twice, protocol error.\n", param->name);
 		return -1;
 	}
 
@@ -1040,9 +1032,9 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 				return -1;
 
 			conn->conn_ops->MaxRecvDataSegmentLength = tmp;
-			pr_debug("Saving op->MaxRecvDataSegmentLength from"
-				" original initiator received value: %u\n",
-				conn->conn_ops->MaxRecvDataSegmentLength);
+			target_debug("Saving op->MaxRecvDataSegmentLength from"
+				     " original initiator received value: %u\n",
+				     conn->conn_ops->MaxRecvDataSegmentLength);
 
 			param_mxdsl = iscsi_find_param_from_key(
 						MAXXMITDATASEGMENTLENGTH,
@@ -1055,16 +1047,17 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 			if (rc < 0)
 				return -1;
 
-			pr_debug("Updated %s to target MXDSL value: %s\n",
-					param->name, param->value);
+			target_debug("Updated %s to target MXDSL value: %s\n", param->name,
+				     param->value);
 		}
 	} else if (IS_TYPE_VALUE_LIST(param)) {
 		negotiated_value = iscsi_check_valuelist_for_support(
 					param, value);
 		if (!negotiated_value) {
-			pr_err("Proposer's value list \"%s\" contains"
-				" no valid values from Acceptor's value list"
-				" \"%s\".\n", value, param->value);
+			target_err("Proposer's value list \"%s\" contains"
+				   " no valid values from Acceptor's value list"
+				   " \"%s\".\n",
+				   value, param->value);
 			return -1;
 		}
 		if (iscsi_update_param_value(param, negotiated_value) < 0)
@@ -1081,8 +1074,7 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value,
 static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 {
 	if (IS_PSTATE_RESPONSE_GOT(param)) {
-		pr_err("Received key \"%s\" twice, protocol error.\n",
-				param->name);
+		target_err("Received key \"%s\" twice, protocol error.\n", param->name);
 		return -1;
 	}
 
@@ -1091,8 +1083,7 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 
 		comma_ptr = strchr(value, ',');
 		if (comma_ptr) {
-			pr_err("Illegal \",\" in response for \"%s\".\n",
-					param->name);
+			target_err("Illegal \",\" in response for \"%s\".\n", param->name);
 			return -1;
 		}
 
@@ -1121,24 +1112,24 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			SET_PSTATE_REJECT(param);
 			return 0;
 		}
-		pr_err("Received %s=%s\n", param->name, value);
+		target_err("Received %s=%s\n", param->name, value);
 		return -1;
 	}
 	if (!strcmp(value, IRRELEVANT)) {
-		pr_debug("Received %s=%s\n", param->name, value);
+		target_debug("Received %s=%s\n", param->name, value);
 		SET_PSTATE_IRRELEVANT(param);
 		return 0;
 	}
 	if (!strcmp(value, NOTUNDERSTOOD)) {
 		if (!IS_PSTATE_PROPOSER(param)) {
-			pr_err("Received illegal offer %s=%s\n",
-				param->name, value);
+			target_err("Received illegal offer %s=%s\n", param->name, value);
 			return -1;
 		}
 
 /* #warning FIXME: Add check for X-ExtensionKey here */
-		pr_err("Standard iSCSI key \"%s\" cannot be answered"
-			" with \"%s\", protocol error.\n", param->name, value);
+		target_err("Standard iSCSI key \"%s\" cannot be answered"
+			   " with \"%s\", protocol error.\n",
+			   param->name, value);
 		return -1;
 	}
 
@@ -1147,18 +1138,19 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		comma_ptr = strchr(value, ',');
 
 		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
-			pr_err("Detected value separator \",\", but"
-				" key \"%s\" does not allow a value list,"
-				" protocol error.\n", param->name);
+			target_err("Detected value separator \",\", but"
+				   " key \"%s\" does not allow a value list,"
+				   " protocol error.\n",
+				   param->name);
 			return -1;
 		}
 		if (comma_ptr)
 			*comma_ptr = '\0';
 
 		if (strlen(value) > VALUE_MAXLEN) {
-			pr_err("Value for key \"%s\" exceeds %d,"
-				" protocol error.\n", param->name,
-				VALUE_MAXLEN);
+			target_err("Value for key \"%s\" exceeds %d,"
+				   " protocol error.\n",
+				   param->name, VALUE_MAXLEN);
 			return -1;
 		}
 
@@ -1172,7 +1164,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 			if (iscsi_check_string_or_list_value(param, value) < 0)
 				return -1;
 		} else {
-			pr_err("Huh? 0x%02x\n", param->type);
+			target_err("Huh? 0x%02x\n", param->type);
 			return -1;
 		}
 
@@ -1193,8 +1185,7 @@ static struct iscsi_param *__iscsi_check_key(
 	struct iscsi_param *param;
 
 	if (strlen(key) > KEY_MAXLEN) {
-		pr_err("Length of key name \"%s\" exceeds %d.\n",
-			key, KEY_MAXLEN);
+		target_err("Length of key name \"%s\" exceeds %d.\n", key, KEY_MAXLEN);
 		return NULL;
 	}
 
@@ -1203,16 +1194,16 @@ static struct iscsi_param *__iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		pr_err("Key \"%s\" may not be sent to %s,"
-			" protocol error.\n", param->name,
-			(sender & SENDER_RECEIVER) ? "target" : "initiator");
+		target_err("Key \"%s\" may not be sent to %s,"
+			   " protocol error.\n",
+			   param->name, (sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		pr_err("Key \"%s\" may not be sent to %s,"
-			" protocol error.\n", param->name,
-			(sender & SENDER_RECEIVER) ? "initiator" : "target");
+		target_err("Key \"%s\" may not be sent to %s,"
+			   " protocol error.\n",
+			   param->name, (sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
 	}
 
@@ -1230,8 +1221,7 @@ static struct iscsi_param *iscsi_check_key(
 	 * Key name length must not exceed 63 bytes. (See iSCSI v20 5.1)
 	 */
 	if (strlen(key) > KEY_MAXLEN) {
-		pr_err("Length of key name \"%s\" exceeds %d.\n",
-			key, KEY_MAXLEN);
+		target_err("Length of key name \"%s\" exceeds %d.\n", key, KEY_MAXLEN);
 		return NULL;
 	}
 
@@ -1240,21 +1230,20 @@ static struct iscsi_param *iscsi_check_key(
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
-		pr_err("Key \"%s\" may not be sent to %s,"
-			" protocol error.\n", param->name,
-			(sender & SENDER_RECEIVER) ? "target" : "initiator");
+		target_err("Key \"%s\" may not be sent to %s,"
+			   " protocol error.\n",
+			   param->name, (sender & SENDER_RECEIVER) ? "target" : "initiator");
 		return NULL;
 	}
 	if ((sender & SENDER_TARGET) && !IS_SENDER_TARGET(param)) {
-		pr_err("Key \"%s\" may not be sent to %s,"
-				" protocol error.\n", param->name,
-			(sender & SENDER_RECEIVER) ? "initiator" : "target");
+		target_err("Key \"%s\" may not be sent to %s,"
+			   " protocol error.\n",
+			   param->name, (sender & SENDER_RECEIVER) ? "initiator" : "target");
 		return NULL;
 	}
 
 	if (IS_PSTATE_ACCEPTOR(param)) {
-		pr_err("Key \"%s\" received twice, protocol error.\n",
-				key);
+		target_err("Key \"%s\" received twice, protocol error.\n", key);
 		return NULL;
 	}
 
@@ -1274,8 +1263,8 @@ static struct iscsi_param *iscsi_check_key(
 		default:
 			phase_name = "Unknown";
 		}
-		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
-				param->name, phase_name);
+		target_err("Key \"%s\" may not be negotiated during %s phase.\n", param->name,
+			   phase_name);
 		return NULL;
 	}
 
@@ -1319,16 +1308,16 @@ static int iscsi_enforce_integrity_rules(
 			if (strcmp(param->value, "1")) {
 				if (iscsi_update_param_value(param, "1") < 0)
 					return -1;
-				pr_debug("Reset \"%s\" to \"%s\".\n",
-					param->name, param->value);
+				target_debug("Reset \"%s\" to \"%s\".\n", param->name,
+					     param->value);
 			}
 		}
 		if (!strcmp(param->name, MAXCONNECTIONS) && !SessionType) {
 			if (strcmp(param->value, "1")) {
 				if (iscsi_update_param_value(param, "1") < 0)
 					return -1;
-				pr_debug("Reset \"%s\" to \"%s\".\n",
-					param->name, param->value);
+				target_debug("Reset \"%s\" to \"%s\".\n", param->name,
+					     param->value);
 			}
 		}
 		if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
@@ -1340,8 +1329,8 @@ static int iscsi_enforce_integrity_rules(
 				sprintf(tmpbuf, "%u", MaxBurstLength);
 				if (iscsi_update_param_value(param, tmpbuf))
 					return -1;
-				pr_debug("Reset \"%s\" to \"%s\".\n",
-					param->name, param->value);
+				target_debug("Reset \"%s\" to \"%s\".\n", param->name,
+					     param->value);
 			}
 		}
 	}
@@ -1361,7 +1350,7 @@ int iscsi_decode_text_input(
 
 	tmpbuf = kmemdup_nul(textbuf, length, GFP_KERNEL);
 	if (!tmpbuf) {
-		pr_err("Unable to allocate %u + 1 bytes for tmpbuf.\n", length);
+		target_err("Unable to allocate %u + 1 bytes for tmpbuf.\n", length);
 		return -ENOMEM;
 	}
 
@@ -1375,7 +1364,7 @@ int iscsi_decode_text_input(
 		if (iscsi_extract_key_value(start, &key, &value) < 0)
 			goto free_buffer;
 
-		pr_debug("Got key: %s=%s\n", key, value);
+		target_debug("Got key: %s=%s\n", key, value);
 
 		if (phase & PHASE_SECURITY) {
 			if (iscsi_check_for_auth_key(key) > 0) {
@@ -1448,8 +1437,7 @@ int iscsi_encode_text_output(
 			*length += 1;
 			output_buf = textbuf + *length;
 			SET_PSTATE_RESPONSE_SENT(param);
-			pr_debug("Sending key: %s=%s\n",
-				param->name, param->value);
+			target_debug("Sending key: %s=%s\n", param->name, param->value);
 			continue;
 		}
 		if (IS_PSTATE_NEGOTIATE(param) &&
@@ -1463,8 +1451,7 @@ int iscsi_encode_text_output(
 			SET_PSTATE_PROPOSER(param);
 			iscsi_check_proposer_for_optional_reply(param,
 							        keys_workaround);
-			pr_debug("Sending key: %s=%s\n",
-				param->name, param->value);
+			target_debug("Sending key: %s=%s\n", param->name, param->value);
 		}
 	}
 
@@ -1472,7 +1459,7 @@ int iscsi_encode_text_output(
 		*length += sprintf(output_buf, "%s=%s", er->key, er->value);
 		*length += 1;
 		output_buf = textbuf + *length;
-		pr_debug("Sending key: %s=%s\n", er->key, er->value);
+		target_debug("Sending key: %s=%s\n", er->key, er->value);
 	}
 	iscsi_release_extra_responses(param_list);
 
@@ -1490,8 +1477,7 @@ int iscsi_check_negotiated_keys(struct iscsi_param_list *param_list)
 		    !IS_PSTATE_RESPONSE_GOT(param) &&
 		    !IS_PSTATE_REPLY_OPTIONAL(param) &&
 		    !IS_PHASE_DECLARATIVE(param)) {
-			pr_err("No response for proposed key \"%s\".\n",
-					param->name);
+			target_err("No response for proposed key \"%s\".\n", param->name);
 			ret = -1;
 		}
 	}
@@ -1541,8 +1527,8 @@ void iscsi_set_connection_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	pr_debug("---------------------------------------------------"
-			"---------------\n");
+	target_debug("---------------------------------------------------"
+		     "---------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		/*
 		 * Special case to set MAXXMITDATASEGMENTLENGTH from the
@@ -1552,51 +1538,45 @@ void iscsi_set_connection_parameters(
 		if (!strcmp(param->name, MAXXMITDATASEGMENTLENGTH)) {
 			ops->MaxXmitDataSegmentLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("MaxXmitDataSegmentLength:     %s\n",
-				param->value);
+			target_debug("MaxXmitDataSegmentLength:     %s\n", param->value);
 		}
 
 		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
 			continue;
 		if (!strcmp(param->name, AUTHMETHOD)) {
-			pr_debug("AuthMethod:                   %s\n",
-				param->value);
+			target_debug("AuthMethod:                   %s\n", param->value);
 		} else if (!strcmp(param->name, HEADERDIGEST)) {
 			ops->HeaderDigest = !strcmp(param->value, CRC32C);
-			pr_debug("HeaderDigest:                 %s\n",
-				param->value);
+			target_debug("HeaderDigest:                 %s\n", param->value);
 		} else if (!strcmp(param->name, DATADIGEST)) {
 			ops->DataDigest = !strcmp(param->value, CRC32C);
-			pr_debug("DataDigest:                   %s\n",
-				param->value);
+			target_debug("DataDigest:                   %s\n", param->value);
 		} else if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH)) {
 			/*
 			 * At this point iscsi_check_acceptor_state() will have
 			 * set ops->MaxRecvDataSegmentLength from the original
 			 * initiator provided value.
 			 */
-			pr_debug("MaxRecvDataSegmentLength:     %u\n",
-				ops->MaxRecvDataSegmentLength);
+			target_debug("MaxRecvDataSegmentLength:     %u\n",
+				     ops->MaxRecvDataSegmentLength);
 		} else if (!strcmp(param->name, INITIATORRECVDATASEGMENTLENGTH)) {
 			ops->InitiatorRecvDataSegmentLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("InitiatorRecvDataSegmentLength: %s\n",
-				param->value);
+			target_debug("InitiatorRecvDataSegmentLength: %s\n", param->value);
 			ops->MaxRecvDataSegmentLength =
 					ops->InitiatorRecvDataSegmentLength;
-			pr_debug("Set MRDSL from InitiatorRecvDataSegmentLength\n");
+			target_debug("Set MRDSL from InitiatorRecvDataSegmentLength\n");
 		} else if (!strcmp(param->name, TARGETRECVDATASEGMENTLENGTH)) {
 			ops->TargetRecvDataSegmentLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("TargetRecvDataSegmentLength:  %s\n",
-				param->value);
+			target_debug("TargetRecvDataSegmentLength:  %s\n", param->value);
 			ops->MaxXmitDataSegmentLength =
 					ops->TargetRecvDataSegmentLength;
-			pr_debug("Set MXDSL from TargetRecvDataSegmentLength\n");
+			target_debug("Set MXDSL from TargetRecvDataSegmentLength\n");
 		}
 	}
-	pr_debug("----------------------------------------------------"
-			"--------------\n");
+	target_debug("----------------------------------------------------"
+		     "--------------\n");
 }
 
 void iscsi_set_session_parameters(
@@ -1607,8 +1587,8 @@ void iscsi_set_session_parameters(
 	char *tmpptr;
 	struct iscsi_param *param;
 
-	pr_debug("----------------------------------------------------"
-			"--------------\n");
+	target_debug("----------------------------------------------------"
+		     "--------------\n");
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		if (!IS_PSTATE_ACCEPTOR(param) && !IS_PSTATE_PROPOSER(param))
 			continue;
@@ -1619,16 +1599,14 @@ void iscsi_set_session_parameters(
 				snprintf(ops->InitiatorName,
 						sizeof(ops->InitiatorName),
 						"%s", param->value);
-			pr_debug("InitiatorName:                %s\n",
-				param->value);
+			target_debug("InitiatorName:                %s\n", param->value);
 		} else if (!strcmp(param->name, INITIATORALIAS)) {
 			if (!param->value)
 				continue;
 			snprintf(ops->InitiatorAlias,
 						sizeof(ops->InitiatorAlias),
 						"%s", param->value);
-			pr_debug("InitiatorAlias:               %s\n",
-				param->value);
+			target_debug("InitiatorAlias:               %s\n", param->value);
 		} else if (!strcmp(param->name, TARGETNAME)) {
 			if (!param->value)
 				continue;
@@ -1636,82 +1614,65 @@ void iscsi_set_session_parameters(
 				snprintf(ops->TargetName,
 						sizeof(ops->TargetName),
 						"%s", param->value);
-			pr_debug("TargetName:                   %s\n",
-				param->value);
+			target_debug("TargetName:                   %s\n", param->value);
 		} else if (!strcmp(param->name, TARGETALIAS)) {
 			if (!param->value)
 				continue;
 			snprintf(ops->TargetAlias, sizeof(ops->TargetAlias),
 					"%s", param->value);
-			pr_debug("TargetAlias:                  %s\n",
-				param->value);
+			target_debug("TargetAlias:                  %s\n", param->value);
 		} else if (!strcmp(param->name, TARGETPORTALGROUPTAG)) {
 			ops->TargetPortalGroupTag =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("TargetPortalGroupTag:         %s\n",
-				param->value);
+			target_debug("TargetPortalGroupTag:         %s\n", param->value);
 		} else if (!strcmp(param->name, MAXCONNECTIONS)) {
 			ops->MaxConnections =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("MaxConnections:               %s\n",
-				param->value);
+			target_debug("MaxConnections:               %s\n", param->value);
 		} else if (!strcmp(param->name, INITIALR2T)) {
 			ops->InitialR2T = !strcmp(param->value, YES);
-			pr_debug("InitialR2T:                   %s\n",
-				param->value);
+			target_debug("InitialR2T:                   %s\n", param->value);
 		} else if (!strcmp(param->name, IMMEDIATEDATA)) {
 			ops->ImmediateData = !strcmp(param->value, YES);
-			pr_debug("ImmediateData:                %s\n",
-				param->value);
+			target_debug("ImmediateData:                %s\n", param->value);
 		} else if (!strcmp(param->name, MAXBURSTLENGTH)) {
 			ops->MaxBurstLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("MaxBurstLength:               %s\n",
-				param->value);
+			target_debug("MaxBurstLength:               %s\n", param->value);
 		} else if (!strcmp(param->name, FIRSTBURSTLENGTH)) {
 			ops->FirstBurstLength =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("FirstBurstLength:             %s\n",
-				param->value);
+			target_debug("FirstBurstLength:             %s\n", param->value);
 		} else if (!strcmp(param->name, DEFAULTTIME2WAIT)) {
 			ops->DefaultTime2Wait =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("DefaultTime2Wait:             %s\n",
-				param->value);
+			target_debug("DefaultTime2Wait:             %s\n", param->value);
 		} else if (!strcmp(param->name, DEFAULTTIME2RETAIN)) {
 			ops->DefaultTime2Retain =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("DefaultTime2Retain:           %s\n",
-				param->value);
+			target_debug("DefaultTime2Retain:           %s\n", param->value);
 		} else if (!strcmp(param->name, MAXOUTSTANDINGR2T)) {
 			ops->MaxOutstandingR2T =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("MaxOutstandingR2T:            %s\n",
-				param->value);
+			target_debug("MaxOutstandingR2T:            %s\n", param->value);
 		} else if (!strcmp(param->name, DATAPDUINORDER)) {
 			ops->DataPDUInOrder = !strcmp(param->value, YES);
-			pr_debug("DataPDUInOrder:               %s\n",
-				param->value);
+			target_debug("DataPDUInOrder:               %s\n", param->value);
 		} else if (!strcmp(param->name, DATASEQUENCEINORDER)) {
 			ops->DataSequenceInOrder = !strcmp(param->value, YES);
-			pr_debug("DataSequenceInOrder:          %s\n",
-				param->value);
+			target_debug("DataSequenceInOrder:          %s\n", param->value);
 		} else if (!strcmp(param->name, ERRORRECOVERYLEVEL)) {
 			ops->ErrorRecoveryLevel =
 				simple_strtoul(param->value, &tmpptr, 0);
-			pr_debug("ErrorRecoveryLevel:           %s\n",
-				param->value);
+			target_debug("ErrorRecoveryLevel:           %s\n", param->value);
 		} else if (!strcmp(param->name, SESSIONTYPE)) {
 			ops->SessionType = !strcmp(param->value, DISCOVERY);
-			pr_debug("SessionType:                  %s\n",
-				param->value);
+			target_debug("SessionType:                  %s\n", param->value);
 		} else if (!strcmp(param->name, RDMAEXTENSIONS)) {
 			ops->RDMAExtensions = !strcmp(param->value, YES);
-			pr_debug("RDMAExtensions:               %s\n",
-				param->value);
+			target_debug("RDMAExtensions:               %s\n", param->value);
 		}
 	}
-	pr_debug("----------------------------------------------------"
-			"--------------\n");
-
+	target_debug("----------------------------------------------------"
+		     "--------------\n");
 }
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 66de2b8de463..a563b780d8e5 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -23,16 +23,15 @@ static void iscsit_dump_seq_list(struct iscsit_cmd *cmd)
 	int i;
 	struct iscsi_seq *seq;
 
-	pr_debug("Dumping Sequence List for ITT: 0x%08x:\n",
-			cmd->init_task_tag);
+	target_debug("Dumping Sequence List for ITT: 0x%08x:\n", cmd->init_task_tag);
 
 	for (i = 0; i < cmd->seq_count; i++) {
 		seq = &cmd->seq_list[i];
-		pr_debug("i: %d, pdu_start: %d, pdu_count: %d,"
-			" offset: %d, xfer_len: %d, seq_send_order: %d,"
-			" seq_no: %d\n", i, seq->pdu_start, seq->pdu_count,
-			seq->offset, seq->xfer_len, seq->seq_send_order,
-			seq->seq_no);
+		target_debug("i: %d, pdu_start: %d, pdu_count: %d,"
+			     " offset: %d, xfer_len: %d, seq_send_order: %d,"
+			     " seq_no: %d\n",
+			     i, seq->pdu_start, seq->pdu_count, seq->offset, seq->xfer_len,
+			     seq->seq_send_order, seq->seq_no);
 	}
 }
 
@@ -41,14 +40,13 @@ static void iscsit_dump_pdu_list(struct iscsit_cmd *cmd)
 	int i;
 	struct iscsi_pdu *pdu;
 
-	pr_debug("Dumping PDU List for ITT: 0x%08x:\n",
-			cmd->init_task_tag);
+	target_debug("Dumping PDU List for ITT: 0x%08x:\n", cmd->init_task_tag);
 
 	for (i = 0; i < cmd->pdu_count; i++) {
 		pdu = &cmd->pdu_list[i];
-		pr_debug("i: %d, offset: %d, length: %d,"
-			" pdu_send_order: %d, seq_no: %d\n", i, pdu->offset,
-			pdu->length, pdu->pdu_send_order, pdu->seq_no);
+		target_debug("i: %d, offset: %d, length: %d,"
+			     " pdu_send_order: %d, seq_no: %d\n",
+			     i, pdu->offset, pdu->length, pdu->pdu_send_order, pdu->seq_no);
 	}
 }
 #else
@@ -131,8 +129,8 @@ static int iscsit_randomize_pdu_lists(
 		}
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
 		if (!array) {
-			pr_err("Unable to allocate memory"
-				" for random array.\n");
+			target_err("Unable to allocate memory"
+				   " for random array.\n");
 			return -ENOMEM;
 		}
 		iscsit_create_random_array(array, seq_count);
@@ -151,8 +149,8 @@ static int iscsit_randomize_pdu_lists(
 	if (seq_count) {
 		array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
 		if (!array) {
-			pr_err("Unable to allocate memory for"
-				" random array.\n");
+			target_err("Unable to allocate memory for"
+				   " random array.\n");
 			return -ENOMEM;
 		}
 		iscsit_create_random_array(array, seq_count);
@@ -183,7 +181,7 @@ static int iscsit_randomize_seq_lists(
 
 	array = kcalloc(seq_count, sizeof(u32), GFP_KERNEL);
 	if (!array) {
-		pr_err("Unable to allocate memory for random array.\n");
+		target_err("Unable to allocate memory for random array.\n");
 		return -ENOMEM;
 	}
 	iscsit_create_random_array(array, seq_count);
@@ -537,7 +535,7 @@ int iscsit_build_pdu_and_seq_lists(
 	if (!conn->sess->sess_ops->DataSequenceInOrder) {
 		seq = kcalloc(seq_count, sizeof(struct iscsi_seq), GFP_ATOMIC);
 		if (!seq) {
-			pr_err("Unable to allocate struct iscsi_seq list\n");
+			target_err("Unable to allocate struct iscsi_seq list\n");
 			return -ENOMEM;
 		}
 		cmd->seq_list = seq;
@@ -547,7 +545,7 @@ int iscsit_build_pdu_and_seq_lists(
 	if (!conn->sess->sess_ops->DataPDUInOrder) {
 		pdu = kcalloc(pdu_count, sizeof(struct iscsi_pdu), GFP_ATOMIC);
 		if (!pdu) {
-			pr_err("Unable to allocate struct iscsi_pdu list.\n");
+			target_err("Unable to allocate struct iscsi_pdu list.\n");
 			kfree(seq);
 			return -ENOMEM;
 		}
@@ -567,7 +565,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder(
 	struct iscsi_pdu *pdu = NULL;
 
 	if (!cmd->pdu_list) {
-		pr_err("struct iscsit_cmd->pdu_list is NULL!\n");
+		target_err("struct iscsit_cmd->pdu_list is NULL!\n");
 		return NULL;
 	}
 
@@ -577,8 +575,9 @@ struct iscsi_pdu *iscsit_get_pdu_holder(
 		if ((pdu[i].offset == offset) && (pdu[i].length == length))
 			return &pdu[i];
 
-	pr_err("Unable to locate PDU holder for ITT: 0x%08x, Offset:"
-		" %u, Length: %u\n", cmd->init_task_tag, offset, length);
+	target_err("Unable to locate PDU holder for ITT: 0x%08x, Offset:"
+		   " %u, Length: %u\n",
+		   cmd->init_task_tag, offset, length);
 	return NULL;
 }
 
@@ -591,7 +590,7 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 	struct iscsi_pdu *pdu = NULL;
 
 	if (!cmd->pdu_list) {
-		pr_err("struct iscsit_cmd->pdu_list is NULL!\n");
+		target_err("struct iscsit_cmd->pdu_list is NULL!\n");
 		return NULL;
 	}
 
@@ -600,11 +599,11 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 		pdu = &cmd->pdu_list[cmd->pdu_start];
 
 		for (i = 0; pdu[i].seq_no != cmd->seq_no; i++) {
-			pr_debug("pdu[i].seq_no: %d, pdu[i].pdu"
-				"_send_order: %d, pdu[i].offset: %d,"
-				" pdu[i].length: %d\n", pdu[i].seq_no,
-				pdu[i].pdu_send_order, pdu[i].offset,
-				pdu[i].length);
+			target_debug("pdu[i].seq_no: %d, pdu[i].pdu"
+				     "_send_order: %d, pdu[i].offset: %d,"
+				     " pdu[i].length: %d\n",
+				     pdu[i].seq_no, pdu[i].pdu_send_order, pdu[i].offset,
+				     pdu[i].length);
 
 			if (pdu[i].pdu_send_order == cmd->pdu_send_order) {
 				cmd->pdu_send_order++;
@@ -619,27 +618,26 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 		if (cmd->pdu_start < cmd->pdu_count)
 			goto redo;
 
-		pr_err("Command ITT: 0x%08x unable to locate"
-			" struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
-			cmd->init_task_tag, cmd->pdu_send_order);
+		target_err("Command ITT: 0x%08x unable to locate"
+			   " struct iscsi_pdu for cmd->pdu_send_order: %u.\n",
+			   cmd->init_task_tag, cmd->pdu_send_order);
 		return NULL;
 	} else {
 		if (!seq) {
-			pr_err("struct iscsi_seq is NULL!\n");
+			target_err("struct iscsi_seq is NULL!\n");
 			return NULL;
 		}
 
-		pr_debug("seq->pdu_start: %d, seq->pdu_count: %d,"
-			" seq->seq_no: %d\n", seq->pdu_start, seq->pdu_count,
-			seq->seq_no);
+		target_debug("seq->pdu_start: %d, seq->pdu_count: %d,"
+			     " seq->seq_no: %d\n",
+			     seq->pdu_start, seq->pdu_count, seq->seq_no);
 
 		pdu = &cmd->pdu_list[seq->pdu_start];
 
 		if (seq->pdu_send_order == seq->pdu_count) {
-			pr_err("Command ITT: 0x%08x seq->pdu_send"
-				"_order: %u equals seq->pdu_count: %u\n",
-				cmd->init_task_tag, seq->pdu_send_order,
-				seq->pdu_count);
+			target_err("Command ITT: 0x%08x seq->pdu_send"
+				   "_order: %u equals seq->pdu_count: %u\n",
+				   cmd->init_task_tag, seq->pdu_send_order, seq->pdu_count);
 			return NULL;
 		}
 
@@ -650,9 +648,9 @@ struct iscsi_pdu *iscsit_get_pdu_holder_for_seq(
 			}
 		}
 
-		pr_err("Command ITT: 0x%08x unable to locate iscsi"
-			"_pdu_t for seq->pdu_send_order: %u.\n",
-			cmd->init_task_tag, seq->pdu_send_order);
+		target_err("Command ITT: 0x%08x unable to locate iscsi"
+			   "_pdu_t for seq->pdu_send_order: %u.\n",
+			   cmd->init_task_tag, seq->pdu_send_order);
 		return NULL;
 	}
 
@@ -667,15 +665,15 @@ struct iscsi_seq *iscsit_get_seq_holder(
 	u32 i;
 
 	if (!cmd->seq_list) {
-		pr_err("struct iscsit_cmd->seq_list is NULL!\n");
+		target_err("struct iscsit_cmd->seq_list is NULL!\n");
 		return NULL;
 	}
 
 	for (i = 0; i < cmd->seq_count; i++) {
-		pr_debug("seq_list[i].orig_offset: %d, seq_list[i]."
-			"xfer_len: %d, seq_list[i].seq_no %u\n",
-			cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
-			cmd->seq_list[i].seq_no);
+		target_debug("seq_list[i].orig_offset: %d, seq_list[i]."
+			     "xfer_len: %d, seq_list[i].seq_no %u\n",
+			     cmd->seq_list[i].orig_offset, cmd->seq_list[i].xfer_len,
+			     cmd->seq_list[i].seq_no);
 
 		if ((cmd->seq_list[i].orig_offset +
 				cmd->seq_list[i].xfer_len) >=
@@ -683,8 +681,8 @@ struct iscsi_seq *iscsit_get_seq_holder(
 			return &cmd->seq_list[i];
 	}
 
-	pr_err("Unable to locate Sequence holder for ITT: 0x%08x,"
-		" Offset: %u, Length: %u\n", cmd->init_task_tag, offset,
-		length);
+	target_err("Unable to locate Sequence holder for ITT: 0x%08x,"
+		   " Offset: %u, Length: %u\n",
+		   cmd->init_task_tag, offset, length);
 	return NULL;
 }
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 9c4aa01b6351..f40987cc5793 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -39,16 +39,17 @@ u8 iscsit_tmr_abort_task(
 
 	ref_cmd = iscsit_find_cmd_from_itt(conn, hdr->rtt);
 	if (!ref_cmd) {
-		pr_err("Unable to locate RefTaskTag: 0x%08x on CID:"
-			" %hu.\n", hdr->rtt, conn->cid);
+		target_err("Unable to locate RefTaskTag: 0x%08x on CID:"
+			   " %hu.\n",
+			   hdr->rtt, conn->cid);
 		return (iscsi_sna_gte(be32_to_cpu(hdr->refcmdsn), conn->sess->exp_cmd_sn) &&
 			iscsi_sna_lte(be32_to_cpu(hdr->refcmdsn), (u32) atomic_read(&conn->sess->max_cmd_sn))) ?
 			ISCSI_TMF_RSP_COMPLETE : ISCSI_TMF_RSP_NO_TASK;
 	}
 	if (ref_cmd->cmd_sn != be32_to_cpu(hdr->refcmdsn)) {
-		pr_err("RefCmdSN 0x%08x does not equal"
-			" task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
-			hdr->refcmdsn, ref_cmd->cmd_sn);
+		target_err("RefCmdSN 0x%08x does not equal"
+			   " task's CmdSN 0x%08x. Rejecting ABORT_TASK.\n",
+			   hdr->refcmdsn, ref_cmd->cmd_sn);
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 
@@ -71,9 +72,9 @@ int iscsit_tmr_task_warm_reset(
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_warm_reset) {
-		pr_err("TMR Opcode TARGET_WARM_RESET authorization"
-			" failed for Initiator Node: %s\n",
-			sess->se_sess->se_node_acl->initiatorname);
+		target_err("TMR Opcode TARGET_WARM_RESET authorization"
+			   " failed for Initiator Node: %s\n",
+			   sess->se_sess->se_node_acl->initiatorname);
 		return -1;
 	}
 	/*
@@ -91,9 +92,9 @@ int iscsit_tmr_task_cold_reset(
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_cold_reset) {
-		pr_err("TMR Opcode TARGET_COLD_RESET authorization"
-			" failed for Initiator Node: %s\n",
-			sess->se_sess->se_node_acl->initiatorname);
+		target_err("TMR Opcode TARGET_COLD_RESET authorization"
+			   " failed for Initiator Node: %s\n",
+			   sess->se_sess->se_node_acl->initiatorname);
 		return -1;
 	}
 	/*
@@ -114,24 +115,26 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
 	u64 ret, ref_lun;
 
-	pr_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
-		" RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
-		hdr->itt, hdr->rtt, hdr->exp_datasn, conn->cid);
+	target_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
+		     " RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
+		     hdr->itt, hdr->rtt, hdr->exp_datasn, conn->cid);
 
 	if (conn->sess->sess_ops->ErrorRecoveryLevel != 2) {
-		pr_err("TMR TASK_REASSIGN not supported in ERL<2,"
-				" ignoring request.\n");
+		target_err("TMR TASK_REASSIGN not supported in ERL<2,"
+			   " ignoring request.\n");
 		return ISCSI_TMF_RSP_NOT_SUPPORTED;
 	}
 
 	ret = iscsit_find_cmd_for_recovery(conn->sess, &ref_cmd, &cr, hdr->rtt);
 	if (ret == -2) {
-		pr_err("Command ITT: 0x%08x is still alligent to CID:"
-			" %hu\n", ref_cmd->init_task_tag, cr->cid);
+		target_err("Command ITT: 0x%08x is still alligent to CID:"
+			   " %hu\n",
+			   ref_cmd->init_task_tag, cr->cid);
 		return ISCSI_TMF_RSP_TASK_ALLEGIANT;
 	} else if (ret == -1) {
-		pr_err("Unable to locate RefTaskTag: 0x%08x in"
-			" connection recovery command list.\n", hdr->rtt);
+		target_err("Unable to locate RefTaskTag: 0x%08x in"
+			   " connection recovery command list.\n",
+			   hdr->rtt);
 		return ISCSI_TMF_RSP_NO_TASK;
 	}
 	/*
@@ -140,24 +143,24 @@ u8 iscsit_tmr_task_reassign(
 	 */
 	if (cr->maxrecvdatasegmentlength !=
 	    conn->conn_ops->MaxRecvDataSegmentLength) {
-		pr_err("Unable to perform connection recovery for"
-			" differing MaxRecvDataSegmentLength, rejecting"
-			" TMR TASK_REASSIGN.\n");
+		target_err("Unable to perform connection recovery for"
+			   " differing MaxRecvDataSegmentLength, rejecting"
+			   " TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 	if (cr->maxxmitdatasegmentlength !=
 	    conn->conn_ops->MaxXmitDataSegmentLength) {
-		pr_err("Unable to perform connection recovery for"
-			" differing MaxXmitDataSegmentLength, rejecting"
-			" TMR TASK_REASSIGN.\n");
+		target_err("Unable to perform connection recovery for"
+			   " differing MaxXmitDataSegmentLength, rejecting"
+			   " TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 
 	ref_lun = scsilun_to_int(&hdr->lun);
 	if (ref_lun != ref_cmd->se_cmd.orig_fe_lun) {
-		pr_err("Unable to perform connection recovery for"
-			" differing ref_lun: %llu ref_cmd orig_fe_lun: %llu\n",
-			ref_lun, ref_cmd->se_cmd.orig_fe_lun);
+		target_err("Unable to perform connection recovery for"
+			   " differing ref_lun: %llu ref_cmd orig_fe_lun: %llu\n",
+			   ref_lun, ref_cmd->se_cmd.orig_fe_lun);
 		return ISCSI_TMF_RSP_REJECTED;
 	}
 
@@ -185,8 +188,9 @@ static void iscsit_task_reassign_remove_cmd(
 	ret = iscsit_remove_cmd_from_connection_recovery(cmd, sess);
 	spin_unlock(&cr->conn_recovery_cmd_lock);
 	if (!ret) {
-		pr_debug("iSCSI connection recovery successful for CID:"
-			" %hu on SID: %u\n", cr->cid, sess->sid);
+		target_debug("iSCSI connection recovery successful for CID:"
+			     " %hu on SID: %u\n",
+			     cr->cid, sess->sid);
 		iscsit_remove_active_connection_recovery_entry(cr, sess);
 	}
 }
@@ -199,8 +203,9 @@ static int iscsit_task_reassign_complete_nop_out(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			" is NULL!\n", cmd->init_task_tag);
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+			   " is NULL!\n",
+			   cmd->init_task_tag);
 		return -1;
 	}
 	cr = cmd->cr;
@@ -250,9 +255,9 @@ static int iscsit_task_reassign_complete_write(
 	 */
 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
-			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
-				" never sent to transport\n",
-				cmd->init_task_tag, cmd->se_cmd.t_state);
+			target_debug("WRITE ITT: 0x%08x: t_state: %d"
+				     " never sent to transport\n",
+				     cmd->init_task_tag, cmd->se_cmd.t_state);
 			target_execute_cmd(se_cmd);
 			return 0;
 		}
@@ -315,17 +320,17 @@ static int iscsit_task_reassign_complete_read(
 	}
 
 	if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
-		pr_debug("READ ITT: 0x%08x: t_state: %d never sent to"
-			" transport\n", cmd->init_task_tag,
-			cmd->se_cmd.t_state);
+		target_debug("READ ITT: 0x%08x: t_state: %d never sent to"
+			     " transport\n",
+			     cmd->init_task_tag, cmd->se_cmd.t_state);
 		target_submit(se_cmd);
 		return 0;
 	}
 
 	if (!(se_cmd->transport_state & CMD_T_COMPLETE)) {
-		pr_err("READ ITT: 0x%08x: t_state: %d, never returned"
-			" from transport\n", cmd->init_task_tag,
-			cmd->se_cmd.t_state);
+		target_err("READ ITT: 0x%08x: t_state: %d, never returned"
+			   " from transport\n",
+			   cmd->init_task_tag, cmd->se_cmd.t_state);
 		return -1;
 	}
 
@@ -367,8 +372,9 @@ static int iscsit_task_reassign_complete_scsi_cmnd(
 	struct iscsi_conn_recovery *cr;
 
 	if (!cmd->cr) {
-		pr_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
-			" is NULL!\n", cmd->init_task_tag);
+		target_err("struct iscsi_conn_recovery pointer for ITT: 0x%08x"
+			   " is NULL!\n",
+			   cmd->init_task_tag);
 		return -1;
 	}
 	cr = cmd->cr;
@@ -400,8 +406,7 @@ static int iscsit_task_reassign_complete_scsi_cmnd(
 	case DMA_NONE:
 		return iscsit_task_reassign_complete_none(cmd, tmr_req);
 	default:
-		pr_err("Unknown cmd->data_direction: 0x%02x\n",
-				cmd->data_direction);
+		target_err("Unknown cmd->data_direction: 0x%02x\n", cmd->data_direction);
 		return -1;
 	}
 
@@ -416,7 +421,7 @@ static int iscsit_task_reassign_complete(
 	int ret = 0;
 
 	if (!tmr_req->ref_cmd) {
-		pr_err("TMR Request is missing a RefCmd struct iscsit_cmd.\n");
+		target_err("TMR Request is missing a RefCmd struct iscsit_cmd.\n");
 		return -1;
 	}
 	cmd = tmr_req->ref_cmd;
@@ -431,17 +436,18 @@ static int iscsit_task_reassign_complete(
 		ret = iscsit_task_reassign_complete_scsi_cmnd(tmr_req, conn);
 		break;
 	default:
-		 pr_err("Illegal iSCSI Opcode 0x%02x during"
-			" command reallegiance\n", cmd->iscsi_opcode);
+		target_err("Illegal iSCSI Opcode 0x%02x during"
+			   " command reallegiance\n",
+			   cmd->iscsi_opcode);
 		return -1;
 	}
 
 	if (ret != 0)
 		return ret;
 
-	pr_debug("Completed connection reallegiance for Opcode: 0x%02x,"
-		" ITT: 0x%08x to CID: %hu.\n", cmd->iscsi_opcode,
-			cmd->init_task_tag, conn->cid);
+	target_debug("Completed connection reallegiance for Opcode: 0x%02x,"
+		     " ITT: 0x%08x to CID: %hu.\n",
+		     cmd->iscsi_opcode, cmd->init_task_tag, conn->cid);
 
 	return 0;
 }
@@ -727,12 +733,11 @@ static int iscsit_task_reassign_prepare_write(
 			continue;
 
 		if (r2t->seq_complete) {
-			pr_err("Initiator is requesting R2Ts from"
-				" R2TSN: 0x%08x, but R2TSN: 0x%08x, Offset: %u,"
-				" Length: %u is already complete."
-				"   BAD INITIATOR ERL=2 IMPLEMENTATION!\n",
-				tmr_req->exp_data_sn, r2t->r2t_sn,
-				r2t->offset, r2t->xfer_len);
+			target_err("Initiator is requesting R2Ts from"
+				   " R2TSN: 0x%08x, but R2TSN: 0x%08x, Offset: %u,"
+				   " Length: %u is already complete."
+				   "   BAD INITIATOR ERL=2 IMPLEMENTATION!\n",
+				   tmr_req->exp_data_sn, r2t->r2t_sn, r2t->offset, r2t->xfer_len);
 			spin_unlock_bh(&cmd->r2t_lock);
 			return -1;
 		}
@@ -799,19 +804,19 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_FROM_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->data_sn) {
-			pr_err("Received ExpDataSN: 0x%08x for READ"
-				" in TMR TASK_REASSIGN greater than command's"
-				" DataSN: 0x%08x.\n", tmr_req->exp_data_sn,
-				ref_cmd->data_sn);
+			target_err("Received ExpDataSN: 0x%08x for READ"
+				   " in TMR TASK_REASSIGN greater than command's"
+				   " DataSN: 0x%08x.\n",
+				   tmr_req->exp_data_sn, ref_cmd->data_sn);
 			return -1;
 		}
 		if ((ref_cmd->cmd_flags & ICF_GOT_DATACK_SNACK) &&
 		    (tmr_req->exp_data_sn <= ref_cmd->acked_data_sn)) {
-			pr_err("Received ExpDataSN: 0x%08x for READ"
-				" in TMR TASK_REASSIGN for previously"
-				" acknowledged DataIN: 0x%08x,"
-				" protocol error\n", tmr_req->exp_data_sn,
-				ref_cmd->acked_data_sn);
+			target_err("Received ExpDataSN: 0x%08x for READ"
+				   " in TMR TASK_REASSIGN for previously"
+				   " acknowledged DataIN: 0x%08x,"
+				   " protocol error\n",
+				   tmr_req->exp_data_sn, ref_cmd->acked_data_sn);
 			return -1;
 		}
 		return iscsit_task_reassign_prepare_read(tmr_req, conn);
@@ -825,17 +830,16 @@ int iscsit_check_task_reassign_expdatasn(
 	 */
 	if (ref_cmd->data_direction == DMA_TO_DEVICE) {
 		if (tmr_req->exp_data_sn > ref_cmd->r2t_sn) {
-			pr_err("Received ExpDataSN: 0x%08x for WRITE"
-				" in TMR TASK_REASSIGN greater than command's"
-				" R2TSN: 0x%08x.\n", tmr_req->exp_data_sn,
-					ref_cmd->r2t_sn);
+			target_err("Received ExpDataSN: 0x%08x for WRITE"
+				   " in TMR TASK_REASSIGN greater than command's"
+				   " R2TSN: 0x%08x.\n",
+				   tmr_req->exp_data_sn, ref_cmd->r2t_sn);
 			return -1;
 		}
 		return iscsit_task_reassign_prepare_write(tmr_req, conn);
 	}
 
-	pr_err("Unknown iSCSI data_direction: 0x%02x\n",
-			ref_cmd->data_direction);
+	target_err("Unknown iSCSI data_direction: 0x%02x\n", ref_cmd->data_direction);
 
 	return -1;
 }
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index f7bac98fd4fe..532f4cff5bed 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -28,7 +28,7 @@ struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u1
 
 	tpg = kzalloc(sizeof(struct iscsi_portal_group), GFP_KERNEL);
 	if (!tpg) {
-		pr_err("Unable to allocate struct iscsi_portal_group\n");
+		target_err("Unable to allocate struct iscsi_portal_group\n");
 		return NULL;
 	}
 
@@ -55,7 +55,7 @@ int iscsit_load_discovery_tpg(void)
 
 	tpg = iscsit_alloc_portal_group(NULL, 1);
 	if (!tpg) {
-		pr_err("Unable to allocate struct iscsi_portal_group\n");
+		target_err("Unable to allocate struct iscsi_portal_group\n");
 		return -1;
 	}
 	/*
@@ -94,7 +94,7 @@ int iscsit_load_discovery_tpg(void)
 	spin_unlock(&tpg->tpg_state_lock);
 
 	iscsit_global->discovery_tpg = tpg;
-	pr_debug("CORE[0] - Allocated Discovery TPG\n");
+	target_debug("CORE[0] - Allocated Discovery TPG\n");
 
 	return 0;
 free_pl_out:
@@ -172,7 +172,7 @@ static void iscsit_clear_tpg_np_login_thread(
 	bool shutdown)
 {
 	if (!tpg_np->tpg_np) {
-		pr_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
+		target_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
 		return;
 	}
 
@@ -190,7 +190,7 @@ static void iscsit_clear_tpg_np_login_threads(
 	spin_lock(&tpg->tpg_np_lock);
 	list_for_each_entry(tpg_np, &tpg->tpg_gnp_list, tpg_np_list) {
 		if (!tpg_np->tpg_np) {
-			pr_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
+			target_err("struct iscsi_tpg_np->tpg_np is NULL!\n");
 			continue;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
@@ -227,8 +227,9 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_group *tpg)
 {
 	if (tpg->tpg_state != TPG_STATE_FREE) {
-		pr_err("Unable to add iSCSI Target Portal Group: %d"
-			" while not in TPG_STATE_FREE state.\n", tpg->tpgt);
+		target_err("Unable to add iSCSI Target Portal Group: %d"
+			   " while not in TPG_STATE_FREE state.\n",
+			   tpg->tpgt);
 		return -EEXIST;
 	}
 	iscsit_set_default_tpg_attribs(tpg);
@@ -245,8 +246,8 @@ int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_portal_gro
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	list_add_tail(&tpg->tpg_list, &tiqn->tiqn_tpg_list);
 	tiqn->tiqn_ntpgs++;
-	pr_debug("CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group\n",
-			tiqn->tiqn, tpg->tpgt);
+	target_debug("CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group\n", tiqn->tiqn,
+		     tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -270,9 +271,9 @@ int iscsit_tpg_del_portal_group(
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
-		pr_err("Unable to delete iSCSI Target Portal Group:"
-			" %hu while active sessions exist, and force=0\n",
-			tpg->tpgt);
+		target_err("Unable to delete iSCSI Target Portal Group:"
+			   " %hu while active sessions exist, and force=0\n",
+			   tpg->tpgt);
 		tpg->tpg_state = old_state;
 		return -EPERM;
 	}
@@ -293,8 +294,8 @@ int iscsit_tpg_del_portal_group(
 	list_del(&tpg->tpg_list);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-	pr_debug("CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Group\n",
-			tiqn->tiqn, tpg->tpgt);
+	target_debug("CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Group\n", tiqn->tiqn,
+		     tpg->tpgt);
 
 	kfree(tpg);
 	return 0;
@@ -307,8 +308,9 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 	int ret;
 
 	if (tpg->tpg_state == TPG_STATE_ACTIVE) {
-		pr_err("iSCSI target portal group: %hu is already"
-			" active, ignoring request.\n", tpg->tpgt);
+		target_err("iSCSI target portal group: %hu is already"
+			   " active, ignoring request.\n",
+			   tpg->tpgt);
 		return -EINVAL;
 	}
 	/*
@@ -338,8 +340,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs++;
-	pr_debug("iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\n",
-			tpg->tpgt);
+	target_debug("iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -355,8 +356,9 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tpg->tpg_state_lock);
 	if (tpg->tpg_state == TPG_STATE_INACTIVE) {
-		pr_err("iSCSI Target Portal Group: %hu is already"
-			" inactive, ignoring request.\n", tpg->tpgt);
+		target_err("iSCSI Target Portal Group: %hu is already"
+			   " inactive, ignoring request.\n",
+			   tpg->tpgt);
 		spin_unlock(&tpg->tpg_state_lock);
 		return -EINVAL;
 	}
@@ -369,9 +371,9 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 		spin_lock(&tpg->tpg_state_lock);
 		tpg->tpg_state = old_state;
 		spin_unlock(&tpg->tpg_state_lock);
-		pr_err("Unable to disable iSCSI Target Portal Group:"
-			" %hu while active sessions exist, and force=0\n",
-			tpg->tpgt);
+		target_err("Unable to disable iSCSI Target Portal Group:"
+			   " %hu while active sessions exist, and force=0\n",
+			   tpg->tpgt);
 		return -EPERM;
 	}
 
@@ -381,8 +383,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 
 	spin_lock(&tiqn->tiqn_tpg_lock);
 	tiqn->tiqn_active_tpgs--;
-	pr_debug("iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group\n",
-			tpg->tpgt);
+	target_debug("iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group\n", tpg->tpgt);
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
 	return 0;
@@ -462,17 +463,17 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 	if (!tpg_np_parent) {
 		if (iscsit_tpg_check_network_portal(tpg->tpg_tiqn, sockaddr,
 				network_transport)) {
-			pr_err("Network Portal: %pISc already exists on a"
-				" different TPG on %s\n", sockaddr,
-				tpg->tpg_tiqn->tiqn);
+			target_err("Network Portal: %pISc already exists on a"
+				   " different TPG on %s\n",
+				   sockaddr, tpg->tpg_tiqn->tiqn);
 			return ERR_PTR(-EEXIST);
 		}
 	}
 
 	tpg_np = kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
 	if (!tpg_np) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_tpg_np.\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_tpg_np.\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -506,9 +507,8 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 		spin_unlock(&tpg_np_parent->tpg_np_parent_lock);
 	}
 
-	pr_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n",
-		tpg->tpg_tiqn->tiqn, &np->np_sockaddr, tpg->tpgt,
-		np->np_transport->name);
+	target_debug("CORE[%s] - Added Network Portal: %pISpc,%hu on %s\n", tpg->tpg_tiqn->tiqn,
+		     &np->np_sockaddr, tpg->tpgt, np->np_transport->name);
 
 	return tpg_np;
 }
@@ -520,9 +520,8 @@ static int iscsit_tpg_release_np(
 {
 	iscsit_clear_tpg_np_login_thread(tpg_np, tpg, true);
 
-	pr_debug("CORE[%s] - Removed Network Portal: %pISpc,%hu on %s\n",
-		tpg->tpg_tiqn->tiqn, &np->np_sockaddr, tpg->tpgt,
-		np->np_transport->name);
+	target_debug("CORE[%s] - Removed Network Portal: %pISpc,%hu on %s\n", tpg->tpg_tiqn->tiqn,
+		     &np->np_sockaddr, tpg->tpgt, np->np_transport->name);
 
 	tpg_np->tpg_np = NULL;
 	tpg_np->tpg = NULL;
@@ -543,8 +542,8 @@ int iscsit_tpg_del_network_portal(
 
 	np = tpg_np->tpg_np;
 	if (!np) {
-		pr_err("Unable to locate struct iscsi_np from"
-				" struct iscsi_tpg_np\n");
+		target_err("Unable to locate struct iscsi_np from"
+			   " struct iscsi_tpg_np\n");
 		return -EINVAL;
 	}
 
@@ -559,8 +558,9 @@ int iscsit_tpg_del_network_portal(
 				tpg_np_child_list) {
 			ret = iscsit_tpg_del_network_portal(tpg, tpg_np_child);
 			if (ret < 0)
-				pr_err("iscsit_tpg_del_network_portal()"
-					" failed: %d\n", ret);
+				target_err("iscsit_tpg_del_network_portal()"
+					   " failed: %d\n",
+					   ret);
 		}
 	} else {
 		/*
@@ -590,8 +590,9 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((authentication != 1) && (authentication != 0)) {
-		pr_err("Illegal value for authentication parameter:"
-			" %u, ignoring request.\n", authentication);
+		target_err("Illegal value for authentication parameter:"
+			   " %u, ignoring request.\n",
+			   authentication);
 		return -EINVAL;
 	}
 
@@ -636,8 +637,8 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 
 out:
 	a->authentication = authentication;
-	pr_debug("%s iSCSI Authentication Methods for TPG: %hu.\n",
-		a->authentication ? "Enforcing" : "Disabling", tpg->tpgt);
+	target_debug("%s iSCSI Authentication Methods for TPG: %hu.\n",
+		     a->authentication ? "Enforcing" : "Disabling", tpg->tpgt);
 
 	return 0;
 }
@@ -649,18 +650,21 @@ int iscsit_ta_login_timeout(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (login_timeout > TA_LOGIN_TIMEOUT_MAX) {
-		pr_err("Requested Login Timeout %u larger than maximum"
-			" %u\n", login_timeout, TA_LOGIN_TIMEOUT_MAX);
+		target_err("Requested Login Timeout %u larger than maximum"
+			   " %u\n",
+			   login_timeout, TA_LOGIN_TIMEOUT_MAX);
 		return -EINVAL;
 	} else if (login_timeout < TA_LOGIN_TIMEOUT_MIN) {
-		pr_err("Requested Logout Timeout %u smaller than"
-			" minimum %u\n", login_timeout, TA_LOGIN_TIMEOUT_MIN);
+		target_err("Requested Logout Timeout %u smaller than"
+			   " minimum %u\n",
+			   login_timeout, TA_LOGIN_TIMEOUT_MIN);
 		return -EINVAL;
 	}
 
 	a->login_timeout = login_timeout;
-	pr_debug("Set Logout Timeout to %u for Target Portal Group"
-		" %hu\n", a->login_timeout, tpg->tpgt);
+	target_debug("Set Logout Timeout to %u for Target Portal Group"
+		     " %hu\n",
+		     a->login_timeout, tpg->tpgt);
 
 	return 0;
 }
@@ -672,17 +676,17 @@ int iscsit_ta_generate_node_acls(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->generate_node_acls = flag;
-	pr_debug("iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n",
-		tpg->tpgt, (a->generate_node_acls) ? "Enabled" : "Disabled");
+	target_debug("iSCSI_TPG[%hu] - Generate Initiator Portal Group ACLs: %s\n", tpg->tpgt,
+		     (a->generate_node_acls) ? "Enabled" : "Disabled");
 
 	if (flag == 1 && a->cache_dynamic_acls == 0) {
-		pr_debug("Explicitly setting cache_dynamic_acls=1 when "
-			"generate_node_acls=1\n");
+		target_debug("Explicitly setting cache_dynamic_acls=1 when "
+			     "generate_node_acls=1\n");
 		a->cache_dynamic_acls = 1;
 	}
 
@@ -696,20 +700,20 @@ int iscsit_ta_default_cmdsn_depth(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if (tcq_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
-		pr_err("Requested Default Queue Depth: %u larger"
-			" than maximum %u\n", tcq_depth,
-				TA_DEFAULT_CMDSN_DEPTH_MAX);
+		target_err("Requested Default Queue Depth: %u larger"
+			   " than maximum %u\n",
+			   tcq_depth, TA_DEFAULT_CMDSN_DEPTH_MAX);
 		return -EINVAL;
 	} else if (tcq_depth < TA_DEFAULT_CMDSN_DEPTH_MIN) {
-		pr_err("Requested Default Queue Depth: %u smaller"
-			" than minimum %u\n", tcq_depth,
-				TA_DEFAULT_CMDSN_DEPTH_MIN);
+		target_err("Requested Default Queue Depth: %u smaller"
+			   " than minimum %u\n",
+			   tcq_depth, TA_DEFAULT_CMDSN_DEPTH_MIN);
 		return -EINVAL;
 	}
 
 	a->default_cmdsn_depth = tcq_depth;
-	pr_debug("iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\n",
-		tpg->tpgt, a->default_cmdsn_depth);
+	target_debug("iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\n", tpg->tpgt,
+		     a->default_cmdsn_depth);
 
 	return 0;
 }
@@ -721,20 +725,20 @@ int iscsit_ta_cache_dynamic_acls(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	if (a->generate_node_acls == 1 && flag == 0) {
-		pr_debug("Skipping cache_dynamic_acls=0 when"
-			" generate_node_acls=1\n");
+		target_debug("Skipping cache_dynamic_acls=0 when"
+			     " generate_node_acls=1\n");
 		return 0;
 	}
 
 	a->cache_dynamic_acls = flag;
-	pr_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
-		" ACLs %s\n", tpg->tpgt, (a->cache_dynamic_acls) ?
-		"Enabled" : "Disabled");
+	target_debug("iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Group"
+		     " ACLs %s\n",
+		     tpg->tpgt, (a->cache_dynamic_acls) ? "Enabled" : "Disabled");
 
 	return 0;
 }
@@ -746,13 +750,13 @@ int iscsit_ta_demo_mode_write_protect(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->demo_mode_write_protect = flag;
-	pr_debug("iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n",
-		tpg->tpgt, (a->demo_mode_write_protect) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n", tpg->tpgt,
+		     (a->demo_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -764,14 +768,14 @@ int iscsit_ta_prod_mode_write_protect(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->prod_mode_write_protect = flag;
-	pr_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit:"
-		" %s\n", tpg->tpgt, (a->prod_mode_write_protect) ?
-		"ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - Production Mode Write Protect bit:"
+		     " %s\n",
+		     tpg->tpgt, (a->prod_mode_write_protect) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -783,14 +787,14 @@ int iscsit_ta_demo_mode_discovery(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->demo_mode_discovery = flag;
-	pr_debug("iSCSI_TPG[%hu] - Demo Mode Discovery bit:"
-		" %s\n", tpg->tpgt, (a->demo_mode_discovery) ?
-		"ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - Demo Mode Discovery bit:"
+		     " %s\n",
+		     tpg->tpgt, (a->demo_mode_discovery) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -802,12 +806,12 @@ int iscsit_ta_default_erl(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((default_erl != 0) && (default_erl != 1) && (default_erl != 2)) {
-		pr_err("Illegal value for default_erl: %u\n", default_erl);
+		target_err("Illegal value for default_erl: %u\n", default_erl);
 		return -EINVAL;
 	}
 
 	a->default_erl = default_erl;
-	pr_debug("iSCSI_TPG[%hu] - DefaultERL: %u\n", tpg->tpgt, a->default_erl);
+	target_debug("iSCSI_TPG[%hu] - DefaultERL: %u\n", tpg->tpgt, a->default_erl);
 
 	return 0;
 }
@@ -819,14 +823,14 @@ int iscsit_ta_t10_pi(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->t10_pi = flag;
-	pr_debug("iSCSI_TPG[%hu] - T10 Protection information bit:"
-		" %s\n", tpg->tpgt, (a->t10_pi) ?
-		"ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - T10 Protection information bit:"
+		     " %s\n",
+		     tpg->tpgt, (a->t10_pi) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -838,13 +842,12 @@ int iscsit_ta_fabric_prot_type(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((prot_type != 0) && (prot_type != 1) && (prot_type != 3)) {
-		pr_err("Illegal value for fabric_prot_type: %u\n", prot_type);
+		target_err("Illegal value for fabric_prot_type: %u\n", prot_type);
 		return -EINVAL;
 	}
 
 	a->fabric_prot_type = prot_type;
-	pr_debug("iSCSI_TPG[%hu] - T10 Fabric Protection Type: %u\n",
-		 tpg->tpgt, prot_type);
+	target_debug("iSCSI_TPG[%hu] - T10 Fabric Protection Type: %u\n", tpg->tpgt, prot_type);
 
 	return 0;
 }
@@ -856,13 +859,14 @@ int iscsit_ta_tpg_enabled_sendtargets(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->tpg_enabled_sendtargets = flag;
-	pr_debug("iSCSI_TPG[%hu] - TPG enabled bit required for SendTargets:"
-		" %s\n", tpg->tpgt, (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - TPG enabled bit required for SendTargets:"
+		     " %s\n",
+		     tpg->tpgt, (a->tpg_enabled_sendtargets) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -874,13 +878,13 @@ int iscsit_ta_login_keys_workaround(
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
 	if ((flag != 0) && (flag != 1)) {
-		pr_err("Illegal value %d\n", flag);
+		target_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	a->login_keys_workaround = flag;
-	pr_debug("iSCSI_TPG[%hu] - TPG enabled bit for login keys workaround: %s ",
-		tpg->tpgt, (a->login_keys_workaround) ? "ON" : "OFF");
+	target_debug("iSCSI_TPG[%hu] - TPG enabled bit for login keys workaround: %s ", tpg->tpgt,
+		     (a->login_keys_workaround) ? "ON" : "OFF");
 
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
index 27c85f260459..0658388e9518 100644
--- a/drivers/target/iscsi/iscsi_target_transport.c
+++ b/drivers/target/iscsi/iscsi_target_transport.c
@@ -39,7 +39,7 @@ void iscsit_register_transport(struct iscsit_transport *t)
 	list_add_tail(&t->t_node, &g_transport_list);
 	mutex_unlock(&transport_mutex);
 
-	pr_debug("Registered iSCSI transport: %s\n", t->name);
+	target_debug("Registered iSCSI transport: %s\n", t->name);
 }
 EXPORT_SYMBOL(iscsit_register_transport);
 
@@ -49,6 +49,6 @@ void iscsit_unregister_transport(struct iscsit_transport *t)
 	list_del(&t->t_node);
 	mutex_unlock(&transport_mutex);
 
-	pr_debug("Unregistered iSCSI transport: %s\n", t->name);
+	target_debug("Unregistered iSCSI transport: %s\n", t->name);
 }
 EXPORT_SYMBOL(iscsit_unregister_transport);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 91a75a4a7cc1..26408a9f5546 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -46,7 +46,7 @@ int iscsit_add_r2t_to_list(
 
 	r2t = kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
 	if (!r2t) {
-		pr_err("Unable to allocate memory for struct iscsi_r2t.\n");
+		target_err("Unable to allocate memory for struct iscsi_r2t.\n");
 		return -1;
 	}
 	INIT_LIST_HEAD(&r2t->r2t_list);
@@ -81,8 +81,9 @@ struct iscsi_r2t *iscsit_get_r2t_for_eos(
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	pr_err("Unable to locate R2T for Offset: %u, Length:"
-			" %u\n", offset, length);
+	target_err("Unable to locate R2T for Offset: %u, Length:"
+		   " %u\n",
+		   offset, length);
 	return NULL;
 }
 
@@ -99,8 +100,9 @@ struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsit_cmd *cmd)
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
 
-	pr_err("Unable to locate next R2T to send for ITT:"
-			" 0x%08x.\n", cmd->init_task_tag);
+	target_err("Unable to locate next R2T to send for ITT:"
+		   " 0x%08x.\n",
+		   cmd->init_task_tag);
 	return NULL;
 }
 
@@ -204,7 +206,7 @@ struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsit_cmd *cmd)
 	u32 i;
 
 	if (!cmd->seq_list) {
-		pr_err("struct iscsit_cmd->seq_list is NULL!\n");
+		target_err("struct iscsit_cmd->seq_list is NULL!\n");
 		return NULL;
 	}
 
@@ -251,27 +253,28 @@ static inline int iscsit_check_received_cmdsn(struct iscsit_session *sess, u32 c
 	 */
 	max_cmdsn = atomic_read(&sess->max_cmd_sn);
 	if (iscsi_sna_gt(cmdsn, max_cmdsn)) {
-		pr_err("Received CmdSN: 0x%08x is greater than"
-		       " MaxCmdSN: 0x%08x, ignoring.\n", cmdsn, max_cmdsn);
+		target_err("Received CmdSN: 0x%08x is greater than"
+			   " MaxCmdSN: 0x%08x, ignoring.\n",
+			   cmdsn, max_cmdsn);
 		ret = CMDSN_MAXCMDSN_OVERRUN;
 
 	} else if (cmdsn == sess->exp_cmd_sn) {
 		sess->exp_cmd_sn++;
-		pr_debug("Received CmdSN matches ExpCmdSN,"
-		      " incremented ExpCmdSN to: 0x%08x\n",
-		      sess->exp_cmd_sn);
+		target_debug("Received CmdSN matches ExpCmdSN,"
+			     " incremented ExpCmdSN to: 0x%08x\n",
+			     sess->exp_cmd_sn);
 		ret = CMDSN_NORMAL_OPERATION;
 
 	} else if (iscsi_sna_gt(cmdsn, sess->exp_cmd_sn)) {
-		pr_debug("Received CmdSN: 0x%08x is greater"
-		      " than ExpCmdSN: 0x%08x, not acknowledging.\n",
-		      cmdsn, sess->exp_cmd_sn);
+		target_debug("Received CmdSN: 0x%08x is greater"
+			     " than ExpCmdSN: 0x%08x, not acknowledging.\n",
+			     cmdsn, sess->exp_cmd_sn);
 		ret = CMDSN_HIGHER_THAN_EXP;
 
 	} else {
-		pr_err("Received CmdSN: 0x%08x is less than"
-		       " ExpCmdSN: 0x%08x, ignoring.\n", cmdsn,
-		       sess->exp_cmd_sn);
+		target_err("Received CmdSN: 0x%08x is less than"
+			   " ExpCmdSN: 0x%08x, ignoring.\n",
+			   cmdsn, sess->exp_cmd_sn);
 		ret = CMDSN_LOWER_THAN_EXP;
 	}
 
@@ -341,8 +344,8 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 	u32 payload_length = ntoh24(hdr->dlength);
 
 	if (conn->sess->sess_ops->InitialR2T) {
-		pr_err("Received unexpected unsolicited data"
-			" while InitialR2T=Yes, protocol error.\n");
+		target_err("Received unexpected unsolicited data"
+			   " while InitialR2T=Yes, protocol error.\n");
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
 		return -1;
@@ -350,10 +353,10 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 
 	if ((cmd->first_burst_len + payload_length) >
 	     conn->sess->sess_ops->FirstBurstLength) {
-		pr_err("Total %u bytes exceeds FirstBurstLength: %u"
-			" for this Unsolicited DataOut Burst.\n",
-			(cmd->first_burst_len + payload_length),
-				conn->sess->sess_ops->FirstBurstLength);
+		target_err("Total %u bytes exceeds FirstBurstLength: %u"
+			   " for this Unsolicited DataOut Burst.\n",
+			   (cmd->first_burst_len + payload_length),
+			   conn->sess->sess_ops->FirstBurstLength);
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 		return -1;
@@ -365,11 +368,11 @@ int iscsit_check_unsolicited_dataout(struct iscsit_cmd *cmd, unsigned char *buf)
 	if (((cmd->first_burst_len + payload_length) != cmd->se_cmd.data_length) &&
 	    ((cmd->first_burst_len + payload_length) !=
 	      conn->sess->sess_ops->FirstBurstLength)) {
-		pr_err("Unsolicited non-immediate data received %u"
-			" does not equal FirstBurstLength: %u, and does"
-			" not equal ExpXferLen %u.\n",
-			(cmd->first_burst_len + payload_length),
-			conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.data_length);
+		target_err("Unsolicited non-immediate data received %u"
+			   " does not equal FirstBurstLength: %u, and does"
+			   " not equal ExpXferLen %u.\n",
+			   (cmd->first_burst_len + payload_length),
+			   conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.data_length);
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 		return -1;
@@ -392,8 +395,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_itt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	pr_err("Unable to locate ITT: 0x%08x on CID: %hu",
-			init_task_tag, conn->cid);
+	target_err("Unable to locate ITT: 0x%08x on CID: %hu", init_task_tag, conn->cid);
 	return NULL;
 }
 EXPORT_SYMBOL(iscsit_find_cmd_from_itt);
@@ -416,8 +418,9 @@ struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	pr_err("Unable to locate ITT: 0x%08x on CID: %hu,"
-			" dumping payload\n", init_task_tag, conn->cid);
+	target_err("Unable to locate ITT: 0x%08x on CID: %hu,"
+		   " dumping payload\n",
+		   init_task_tag, conn->cid);
 	if (length)
 		iscsit_dump_data_payload(conn, length, 1);
 
@@ -440,8 +443,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_ttt(
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	pr_err("Unable to locate TTT: 0x%08x on CID: %hu\n",
-			targ_xfer_tag, conn->cid);
+	target_err("Unable to locate TTT: 0x%08x on CID: %hu\n", targ_xfer_tag, conn->cid);
 	return NULL;
 }
 
@@ -506,8 +508,8 @@ void iscsit_add_cmd_to_immediate_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		pr_err("Unable to allocate memory for"
-				" struct iscsi_queue_req\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_queue_req\n");
 		return;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
@@ -567,9 +569,8 @@ static void iscsit_remove_cmd_from_immediate_queue(
 	spin_unlock_bh(&conn->immed_queue_lock);
 
 	if (atomic_read(&cmd->immed_queue_count)) {
-		pr_err("ITT: 0x%08x immed_queue_count: %d\n",
-			cmd->init_task_tag,
-			atomic_read(&cmd->immed_queue_count));
+		target_err("ITT: 0x%08x immed_queue_count: %d\n", cmd->init_task_tag,
+			   atomic_read(&cmd->immed_queue_count));
 	}
 }
 
@@ -582,8 +583,8 @@ int iscsit_add_cmd_to_response_queue(
 
 	qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC);
 	if (!qr) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_queue_req\n");
+		target_err("Unable to allocate memory for"
+			   " struct iscsi_queue_req\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&qr->qr_list);
@@ -644,9 +645,8 @@ static void iscsit_remove_cmd_from_response_queue(
 	spin_unlock_bh(&conn->response_queue_lock);
 
 	if (atomic_read(&cmd->response_queue_count)) {
-		pr_err("ITT: 0x%08x response_queue_count: %d\n",
-			cmd->init_task_tag,
-			atomic_read(&cmd->response_queue_count));
+		target_err("ITT: 0x%08x response_queue_count: %d\n", cmd->init_task_tag,
+			   atomic_read(&cmd->response_queue_count));
 	}
 }
 
@@ -907,10 +907,10 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 		return;
 	}
 
-	pr_err("Did not receive response to NOPIN on CID: %hu, failing"
-		" connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
-		conn->cid, sess->sess_ops->InitiatorName, sess->isid,
-		sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
+	target_err("Did not receive response to NOPIN on CID: %hu, failing"
+		   " connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+		   conn->cid, sess->sess_ops->InitiatorName, sess->isid, sess->tpg->tpg_tiqn->tiqn,
+		   (u32)sess->tpg->tpgt);
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
 	spin_unlock_bh(&conn->nopin_timer_lock);
 
@@ -951,8 +951,9 @@ void iscsit_start_nopin_response_timer(struct iscsit_conn *conn)
 	mod_timer(&conn->nopin_response_timer,
 		  jiffies + na->nopin_response_timeout * HZ);
 
-	pr_debug("Started NOPIN Response Timer on CID: %d to %u"
-		" seconds\n", conn->cid, na->nopin_response_timeout);
+	target_debug("Started NOPIN Response Timer on CID: %d to %u"
+		     " seconds\n",
+		     conn->cid, na->nopin_response_timeout);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
@@ -1012,8 +1013,9 @@ void __iscsit_start_nopin_timer(struct iscsit_conn *conn)
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	mod_timer(&conn->nopin_timer, jiffies + na->nopin_timeout * HZ);
 
-	pr_debug("Started NOPIN Timer on CID: %d at %u second"
-		" interval\n", conn->cid, na->nopin_timeout);
+	target_debug("Started NOPIN Timer on CID: %d at %u second"
+		     " interval\n",
+		     conn->cid, na->nopin_timeout);
 }
 
 void iscsit_start_nopin_timer(struct iscsit_conn *conn)
@@ -1045,14 +1047,14 @@ void iscsit_login_timeout(struct timer_list *t)
 	struct iscsit_conn *conn = from_timer(conn, t, login_timer);
 	struct iscsi_login *login = conn->login;
 
-	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
+	target_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
 
 	spin_lock_bh(&conn->login_timer_lock);
 	login->login_failed = 1;
 
 	if (conn->login_kworker) {
-		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
-			 conn->login_kworker->comm, conn->login_kworker->pid);
+		target_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
+			     conn->login_kworker->comm, conn->login_kworker->pid);
 		send_sig(SIGINT, conn->login_kworker, 1);
 	} else {
 		schedule_delayed_work(&conn->login_work, 0);
@@ -1062,7 +1064,7 @@ void iscsit_login_timeout(struct timer_list *t)
 
 void iscsit_start_login_timer(struct iscsit_conn *conn, struct task_struct *kthr)
 {
-	pr_debug("Login timer started\n");
+	target_debug("Login timer started\n");
 
 	conn->login_kworker = kthr;
 	mod_timer(&conn->login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
@@ -1087,7 +1089,7 @@ int iscsit_set_login_timer_kworker(struct iscsit_conn *conn, struct task_struct
 
 void iscsit_stop_login_timer(struct iscsit_conn *conn)
 {
-	pr_debug("Login timer stopped\n");
+	target_debug("Login timer stopped\n");
 	timer_delete_sync(&conn->login_timer);
 }
 
@@ -1114,7 +1116,7 @@ int iscsit_send_tx_data(
 	tx_sent = tx_data(conn, &iov[0], iov_count, tx_size);
 	if (tx_size != tx_sent) {
 		if (tx_sent == -EAGAIN) {
-			pr_err("tx_data() returned -EAGAIN\n");
+			target_err("tx_data() returned -EAGAIN\n");
 			goto send_data;
 		} else
 			return -1;
@@ -1147,7 +1149,7 @@ int iscsit_fe_sendpage_sg(
 	tx_sent = tx_data(conn, &iov, 1, tx_hdr_size);
 	if (tx_hdr_size != tx_sent) {
 		if (tx_sent == -EAGAIN) {
-			pr_err("tx_data() returned -EAGAIN\n");
+			target_err("tx_data() returned -EAGAIN\n");
 			goto send_hdr;
 		}
 		return -1;
@@ -1181,11 +1183,11 @@ int iscsit_fe_sendpage_sg(
 						   sub_len);
 		if (tx_sent != sub_len) {
 			if (tx_sent == -EAGAIN) {
-				pr_err("sendmsg/splice returned -EAGAIN\n");
+				target_err("sendmsg/splice returned -EAGAIN\n");
 				goto send_pg;
 			}
 
-			pr_err("sendmsg/splice failure: %d\n", tx_sent);
+			target_err("sendmsg/splice failure: %d\n", tx_sent);
 			return -1;
 		}
 
@@ -1201,7 +1203,7 @@ int iscsit_fe_sendpage_sg(
 		tx_sent = tx_data(conn, iov_p, 1, cmd->padding);
 		if (cmd->padding != tx_sent) {
 			if (tx_sent == -EAGAIN) {
-				pr_err("tx_data() returned -EAGAIN\n");
+				target_err("tx_data() returned -EAGAIN\n");
 				goto send_padding;
 			}
 			return -1;
@@ -1215,7 +1217,7 @@ int iscsit_fe_sendpage_sg(
 		tx_sent = tx_data(conn, iov_d, 1, ISCSI_CRC_LEN);
 		if (ISCSI_CRC_LEN != tx_sent) {
 			if (tx_sent == -EAGAIN) {
-				pr_err("tx_data() returned -EAGAIN\n");
+				target_err("tx_data() returned -EAGAIN\n");
 				goto send_datacrc;
 			}
 			return -1;
@@ -1256,8 +1258,9 @@ void iscsit_print_session_params(struct iscsit_session *sess)
 {
 	struct iscsit_conn *conn;
 
-	pr_debug("-----------------------------[Session Params for"
-		" SID: %u]-----------------------------\n", sess->sid);
+	target_debug("-----------------------------[Session Params for"
+		     " SID: %u]-----------------------------\n",
+		     sess->sid);
 	spin_lock_bh(&sess->conn_lock);
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
 		iscsi_dump_conn_ops(conn->conn_ops);
@@ -1284,13 +1287,11 @@ int rx_data(
 	while (msg_data_left(&msg)) {
 		rx_loop = sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
 		if (rx_loop <= 0) {
-			pr_debug("rx_loop: %d total_rx: %d\n",
-				rx_loop, total_rx);
+			target_debug("rx_loop: %d total_rx: %d\n", rx_loop, total_rx);
 			return rx_loop;
 		}
 		total_rx += rx_loop;
-		pr_debug("rx_loop: %d, total_rx: %d, data: %d\n",
-				rx_loop, total_rx, data);
+		target_debug("rx_loop: %d, total_rx: %d, data: %d\n", rx_loop, total_rx, data);
 	}
 
 	return total_rx;
@@ -1309,7 +1310,7 @@ int tx_data(
 		return -1;
 
 	if (data <= 0) {
-		pr_err("Data length is: %d\n", data);
+		target_err("Data length is: %d\n", data);
 		return -1;
 	}
 
@@ -1320,13 +1321,11 @@ int tx_data(
 	while (msg_data_left(&msg)) {
 		int tx_loop = sock_sendmsg(conn->sock, &msg);
 		if (tx_loop <= 0) {
-			pr_debug("tx_loop: %d total_tx %d\n",
-				tx_loop, total_tx);
+			target_debug("tx_loop: %d total_tx %d\n", tx_loop, total_tx);
 			return tx_loop;
 		}
 		total_tx += tx_loop;
-		pr_debug("tx_loop: %d, total_tx: %d, data: %d\n",
-					tx_loop, total_tx, data);
+		target_debug("tx_loop: %d, total_tx: %d, data: %d\n", tx_loop, total_tx, data);
 	}
 
 	return total_tx;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 761c511aea07..0664c09de0b8 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -169,10 +169,9 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
 
-	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
-		 __func__, sc->device->host->host_no, sc->device->id,
-		 sc->device->channel, sc->device->lun, sc->cmnd[0],
-		 scsi_bufflen(sc));
+	target_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n", __func__,
+		     sc->device->host->host_no, sc->device->id, sc->device->channel,
+		     sc->device->lun, sc->cmnd[0], scsi_bufflen(sc));
 
 	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
@@ -200,7 +199,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	 */
 	tl_nexus = tl_tpg->tl_nexus;
 	if (!tl_nexus) {
-		pr_err("Unable to perform device reset without active I_T Nexus\n");
+		target_err("Unable to perform device reset without active I_T Nexus\n");
 		return ret;
 	}
 
@@ -277,7 +276,7 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	 */
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	if (!tl_hba) {
-		pr_err("Unable to perform device reset without active I_T Nexus\n");
+		target_err("Unable to perform device reset without active I_T Nexus\n");
 		return FAILED;
 	}
 	/*
@@ -320,7 +319,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh = scsi_host_alloc(&tcm_loop_driver_template,
 			sizeof(struct tcm_loop_hba));
 	if (!sh) {
-		pr_err("Unable to allocate struct scsi_host\n");
+		target_err("Unable to allocate struct scsi_host\n");
 		return -ENODEV;
 	}
 	tl_hba->sh = sh;
@@ -349,7 +348,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 
 	error = scsi_add_host(sh, &tl_hba->dev);
 	if (error) {
-		pr_err("%s: scsi_add_host failed\n", __func__);
+		target_err("%s: scsi_add_host failed\n", __func__);
 		scsi_host_put(sh);
 		return -ENODEV;
 	}
@@ -389,7 +388,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
-		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		target_err("device_register() failed for tl_hba->dev: %d\n", ret);
 		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
@@ -407,23 +406,23 @@ static int tcm_loop_alloc_core_bus(void)
 
 	tcm_loop_primary = root_device_register("tcm_loop_0");
 	if (IS_ERR(tcm_loop_primary)) {
-		pr_err("Unable to allocate tcm_loop_primary\n");
+		target_err("Unable to allocate tcm_loop_primary\n");
 		return PTR_ERR(tcm_loop_primary);
 	}
 
 	ret = bus_register(&tcm_loop_lld_bus);
 	if (ret) {
-		pr_err("bus_register() failed for tcm_loop_lld_bus\n");
+		target_err("bus_register() failed for tcm_loop_lld_bus\n");
 		goto dev_unreg;
 	}
 
 	ret = driver_register(&tcm_loop_driverfs);
 	if (ret) {
-		pr_err("driver_register() failed for tcm_loop_driverfs\n");
+		target_err("driver_register() failed for tcm_loop_driverfs\n");
 		goto bus_unreg;
 	}
 
-	pr_debug("Initialized TCM Loop Core Bus\n");
+	target_debug("Initialized TCM Loop Core Bus\n");
 	return ret;
 
 bus_unreg:
@@ -439,7 +438,7 @@ static void tcm_loop_release_core_bus(void)
 	bus_unregister(&tcm_loop_lld_bus);
 	root_device_unregister(tcm_loop_primary);
 
-	pr_debug("Releasing TCM Loop Core BUS\n");
+	target_debug("Releasing TCM Loop Core BUS\n");
 }
 
 static inline struct tcm_loop_tpg *tl_tpg(struct se_portal_group *se_tpg)
@@ -515,8 +514,7 @@ static int tcm_loop_queue_data_or_status(const char *func,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 func, sc, sc->cmnd[0]);
+	target_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n", func, sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
@@ -592,7 +590,7 @@ static int tcm_loop_port_link(
 	 */
 	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
 
-	pr_debug("TCM_Loop_ConfigFS: Port Link Successful\n");
+	target_debug("TCM_Loop_ConfigFS: Port Link Successful\n");
 	return 0;
 }
 
@@ -610,8 +608,8 @@ static void tcm_loop_port_unlink(
 	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
 				se_lun->unpacked_lun);
 	if (!sd) {
-		pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
-		       0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
+		target_err("Unable to locate struct scsi_device for %d:%d:%llu\n", 0,
+			   tl_tpg->tl_tpgt, se_lun->unpacked_lun);
 		return;
 	}
 	/*
@@ -622,7 +620,7 @@ static void tcm_loop_port_unlink(
 
 	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);
 
-	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
+	target_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
 }
 
 /* End items for tcm_loop_port_cit */
@@ -647,11 +645,11 @@ static ssize_t tcm_loop_tpg_attrib_fabric_prot_type_store(
 	int ret = kstrtoul(page, 0, &val);
 
 	if (ret) {
-		pr_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
+		target_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
 		return ret;
 	}
 	if (val != 0 && val != 1 && val != 3) {
-		pr_err("Invalid qla2xxx fabric_prot_type: %lu\n", val);
+		target_err("Invalid qla2xxx fabric_prot_type: %lu\n", val);
 		return -EINVAL;
 	}
 	tl_tpg->tl_fabric_prot_type = val;
@@ -687,7 +685,7 @@ static int tcm_loop_make_nexus(
 	int ret;
 
 	if (tl_tpg->tl_nexus) {
-		pr_debug("tl_tpg->tl_nexus already exists\n");
+		target_debug("tl_tpg->tl_nexus already exists\n");
 		return -EEXIST;
 	}
 
@@ -704,8 +702,8 @@ static int tcm_loop_make_nexus(
 		return ret;
 	}
 
-	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
-		 tcm_loop_dump_proto_id(tl_hba), name);
+	target_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
+		     tcm_loop_dump_proto_id(tl_hba), name);
 	return 0;
 }
 
@@ -724,14 +722,14 @@ static int tcm_loop_drop_nexus(
 		return -ENODEV;
 
 	if (atomic_read(&tpg->tl_tpg_port_count)) {
-		pr_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count: %d\n",
-		       atomic_read(&tpg->tl_tpg_port_count));
+		target_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count: %d\n",
+			   atomic_read(&tpg->tl_tpg_port_count));
 		return -EPERM;
 	}
 
-	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated %s Initiator Port: %s\n",
-		 tcm_loop_dump_proto_id(tpg->tl_hba),
-		 tl_nexus->se_sess->se_node_acl->initiatorname);
+	target_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated %s Initiator Port: %s\n",
+		     tcm_loop_dump_proto_id(tpg->tl_hba),
+		     tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated Target Port
 	 */
@@ -783,8 +781,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	 * tcm_loop_make_nexus()
 	 */
 	if (strlen(page) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
-		       page, TL_WWN_ADDR_LEN);
+		target_err("Emulated NAA Sas Address: %s, exceeds max: %d\n", page,
+			   TL_WWN_ADDR_LEN);
 		return -EINVAL;
 	}
 	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
@@ -792,8 +790,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "naa.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
+			target_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
+				   i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
@@ -802,8 +800,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "fc.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
+			target_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
+				   i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[3]; /* Skip over "fc." */
@@ -812,15 +810,14 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "iqn.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
+			target_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
+				   i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
 		goto check_newline;
 	}
-	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
-	       i_port);
+	target_err("Unable to locate prefix for emulated Initiator Port: %s\n", i_port);
 	return -EINVAL;
 	/*
 	 * Clear any trailing newline for the NAA WWN
@@ -920,15 +917,14 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(struct se_wwn *wwn,
 	unsigned long tpgt;
 
 	if (strstr(name, "tpgt_") != name) {
-		pr_err("Unable to locate \"tpgt_#\" directory group\n");
+		target_err("Unable to locate \"tpgt_#\" directory group\n");
 		return ERR_PTR(-EINVAL);
 	}
 	if (kstrtoul(name+5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tpgt >= TL_TPGS_PER_HBA) {
-		pr_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n",
-		       tpgt, TL_TPGS_PER_HBA);
+		target_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
 	}
 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
@@ -941,9 +937,9 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(struct se_wwn *wwn,
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	pr_debug("TCM_Loop_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
-		 tcm_loop_dump_proto_id(tl_hba),
-		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	target_debug("TCM_Loop_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
+		     tcm_loop_dump_proto_id(tl_hba), config_item_name(&wwn->wwn_group.cg_item),
+		     tpgt);
 	return &tl_tpg->tl_se_tpg;
 }
 
@@ -970,9 +966,9 @@ static void tcm_loop_drop_naa_tpg(
 	tl_tpg->tl_hba = NULL;
 	tl_tpg->tl_tpgt = 0;
 
-	pr_debug("TCM_Loop_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
-		 tcm_loop_dump_proto_id(tl_hba),
-		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	target_debug("TCM_Loop_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
+		     tcm_loop_dump_proto_id(tl_hba), config_item_name(&wwn->wwn_group.cg_item),
+		     tpgt);
 }
 
 /* End items for tcm_loop_naa_cit */
@@ -1010,8 +1006,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	}
 	ptr = strstr(name, "iqn.");
 	if (!ptr) {
-		pr_err("Unable to locate prefix for emulated Target Port: %s\n",
-		       name);
+		target_err("Unable to locate prefix for emulated Target Port: %s\n", name);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1019,8 +1014,8 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA %s Address: %s, exceeds max: %d\n",
-		       name, tcm_loop_dump_proto_id(tl_hba), TL_WWN_ADDR_LEN);
+		target_err("Emulated NAA %s Address: %s, exceeds max: %d\n", name,
+			   tcm_loop_dump_proto_id(tl_hba), TL_WWN_ADDR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1037,8 +1032,8 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
-	pr_debug("TCM_Loop_ConfigFS: Allocated emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
-		 tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
+	target_debug("TCM_Loop_ConfigFS: Allocated emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
+		     tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
 	return &tl_hba->tl_hba_wwn;
 out:
 	kfree(tl_hba);
@@ -1051,9 +1046,8 @@ static void tcm_loop_drop_scsi_hba(
 	struct tcm_loop_hba *tl_hba = container_of(wwn,
 				struct tcm_loop_hba, tl_hba_wwn);
 
-	pr_debug("TCM_Loop_ConfigFS: Deallocating emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
-		 tcm_loop_dump_proto_id(tl_hba), tl_hba->tl_wwn_address,
-		 tl_hba->sh->host_no);
+	target_debug("TCM_Loop_ConfigFS: Deallocating emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
+		     tcm_loop_dump_proto_id(tl_hba), tl_hba->tl_wwn_address, tl_hba->sh->host_no);
 	/*
 	 * Call device_unregister() on the original tl_hba->dev.
 	 * tcm_loop_fabric_scsi.c:tcm_loop_release_adapter() will
@@ -1115,7 +1109,7 @@ static int __init tcm_loop_fabric_init(void)
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
-		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
+		target_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
 		goto out;
 	}
 
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index b604fcae21e1..75914c19c872 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -201,7 +201,7 @@ static struct sbp_session *sbp_session_create(
 					     TARGET_PROT_NORMAL, guid_str,
 					     sess, NULL);
 	if (IS_ERR(sess->se_sess)) {
-		pr_err("failed to init se_session\n");
+		target_err("failed to init se_session\n");
 		ret = PTR_ERR(sess->se_sess);
 		kfree(sess);
 		return ERR_PTR(ret);
@@ -271,8 +271,8 @@ static void sbp_management_request_login(
 	unpacked_lun = sbp_get_lun_from_tpg(tpg,
 			LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)), &ret);
 	if (ret) {
-		pr_notice("login to unknown LUN: %d\n",
-			LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)));
+		target_notice("login to unknown LUN: %d\n",
+			      LOGIN_ORB_LUN(be32_to_cpu(req->orb.misc)));
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -282,7 +282,7 @@ static void sbp_management_request_login(
 
 	ret = read_peer_guid(&guid, req);
 	if (ret != RCODE_COMPLETE) {
-		pr_warn("failed to read peer GUID: %d\n", ret);
+		target_warn("failed to read peer GUID: %d\n", ret);
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
@@ -290,14 +290,13 @@ static void sbp_management_request_login(
 		return;
 	}
 
-	pr_notice("mgt_agent LOGIN to LUN %d from %016llx\n",
-		unpacked_lun, guid);
+	target_notice("mgt_agent LOGIN to LUN %d from %016llx\n", unpacked_lun, guid);
 
 	sess = sbp_session_find_by_guid(tpg, guid);
 	if (sess) {
 		login = sbp_login_find_by_lun(sess, unpacked_lun);
 		if (login) {
-			pr_notice("initiator already logged-in\n");
+			target_notice("initiator already logged-in\n");
 
 			/*
 			 * SBP-2 R4 says we should return access denied, but
@@ -324,7 +323,7 @@ static void sbp_management_request_login(
 	 */
 	if (LOGIN_ORB_EXCLUSIVE(be32_to_cpu(req->orb.misc)) &&
 			sbp_login_count_all_by_lun(tpg, unpacked_lun, 0)) {
-		pr_warn("refusing exclusive login with other active logins\n");
+		target_warn("refusing exclusive login with other active logins\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -337,7 +336,7 @@ static void sbp_management_request_login(
 	 * reject with access_denied if any exclusive logins present
 	 */
 	if (sbp_login_count_all_by_lun(tpg, unpacked_lun, 1)) {
-		pr_warn("refusing login while another exclusive login present\n");
+		target_warn("refusing login while another exclusive login present\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -351,7 +350,7 @@ static void sbp_management_request_login(
 	 */
 	if (sbp_login_count_all_by_lun(tpg, unpacked_lun, 0) >=
 			tport->max_logins_per_lun) {
-		pr_warn("max number of logins reached\n");
+		target_warn("max number of logins reached\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -394,7 +393,7 @@ static void sbp_management_request_login(
 
 	login = kmalloc(sizeof(*login), GFP_KERNEL);
 	if (!login) {
-		pr_err("failed to allocate login descriptor\n");
+		target_err("failed to allocate login descriptor\n");
 
 		sbp_session_release(sess, true);
 
@@ -413,7 +412,7 @@ static void sbp_management_request_login(
 	login->tgt_agt = sbp_target_agent_register(login);
 	if (IS_ERR(login->tgt_agt)) {
 		ret = PTR_ERR(login->tgt_agt);
-		pr_err("failed to map command block handler: %d\n", ret);
+		target_err("failed to map command block handler: %d\n", ret);
 
 		sbp_session_release(sess, true);
 		kfree(login);
@@ -431,7 +430,7 @@ static void sbp_management_request_login(
 already_logged_in:
 	response = kzalloc(sizeof(*response), GFP_KERNEL);
 	if (!response) {
-		pr_err("failed to allocate login response block\n");
+		target_err("failed to allocate login response block\n");
 
 		sbp_login_release(login, true);
 
@@ -456,7 +455,7 @@ static void sbp_management_request_login(
 		sbp2_pointer_to_addr(&req->orb.ptr2), response,
 		login_response_len);
 	if (ret != RCODE_COMPLETE) {
-		pr_debug("failed to write login response block: %x\n", ret);
+		target_debug("failed to write login response block: %x\n", ret);
 
 		kfree(response);
 		sbp_login_release(login, true);
@@ -478,7 +477,7 @@ static void sbp_management_request_query_logins(
 	struct sbp_management_agent *agent, struct sbp_management_request *req,
 	int *status_data_size)
 {
-	pr_notice("QUERY LOGINS not implemented\n");
+	target_notice("QUERY LOGINS not implemented\n");
 	/* FIXME: implement */
 
 	req->status.status = cpu_to_be32(
@@ -498,7 +497,7 @@ static void sbp_management_request_reconnect(
 
 	ret = read_peer_guid(&guid, req);
 	if (ret != RCODE_COMPLETE) {
-		pr_warn("failed to read peer GUID: %d\n", ret);
+		target_warn("failed to read peer GUID: %d\n", ret);
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_TRANSPORT_FAILURE) |
@@ -506,13 +505,13 @@ static void sbp_management_request_reconnect(
 		return;
 	}
 
-	pr_notice("mgt_agent RECONNECT from %016llx\n", guid);
+	target_notice("mgt_agent RECONNECT from %016llx\n", guid);
 
 	login = sbp_login_find_by_id(tpg,
 		RECONNECT_ORB_LOGIN_ID(be32_to_cpu(req->orb.misc)));
 
 	if (!login) {
-		pr_err("mgt_agent RECONNECT unknown login ID\n");
+		target_err("mgt_agent RECONNECT unknown login ID\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -521,7 +520,7 @@ static void sbp_management_request_reconnect(
 	}
 
 	if (login->sess->guid != guid) {
-		pr_err("mgt_agent RECONNECT login GUID doesn't match\n");
+		target_err("mgt_agent RECONNECT login GUID doesn't match\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -558,7 +557,7 @@ static void sbp_management_request_logout(
 
 	login = sbp_login_find_by_id(tpg, id);
 	if (!login) {
-		pr_warn("cannot find login: %d\n", id);
+		target_warn("cannot find login: %d\n", id);
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -566,11 +565,10 @@ static void sbp_management_request_logout(
 		return;
 	}
 
-	pr_info("mgt_agent LOGOUT from LUN %d session %d\n",
-		login->login_lun, login->login_id);
+	target_info("mgt_agent LOGOUT from LUN %d session %d\n", login->login_lun, login->login_id);
 
 	if (req->node_addr != login->sess->node_id) {
-		pr_warn("logout from different node ID\n");
+		target_warn("logout from different node ID\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -603,8 +601,7 @@ static void session_check_for_reset(struct sbp_session *sess)
 	}
 
 	if (!card_valid || (sess->generation != sess->card->generation)) {
-		pr_info("Waiting for reconnect from node: %016llx\n",
-				sess->guid);
+		target_info("Waiting for reconnect from node: %016llx\n", sess->guid);
 
 		sess->node_id = -1;
 		sess->reconnect_expires = get_jiffies_64() +
@@ -619,7 +616,7 @@ static void session_reconnect_expired(struct sbp_session *sess)
 	struct sbp_login_descriptor *login, *temp;
 	LIST_HEAD(login_list);
 
-	pr_info("Reconnect timer expired for node: %016llx\n", sess->guid);
+	target_info("Reconnect timer expired for node: %016llx\n", sess->guid);
 
 	spin_lock_bh(&sess->lock);
 	list_for_each_entry_safe(login, temp, &sess->login_list, link) {
@@ -672,7 +669,7 @@ static int tgt_agent_rw_agent_state(struct fw_card *card, int tcode, void *data,
 
 	switch (tcode) {
 	case TCODE_READ_QUADLET_REQUEST:
-		pr_debug("tgt_agent AGENT_STATE READ\n");
+		target_debug("tgt_agent AGENT_STATE READ\n");
 
 		spin_lock_bh(&agent->lock);
 		state = agent->state;
@@ -696,7 +693,7 @@ static int tgt_agent_rw_agent_reset(struct fw_card *card, int tcode, void *data,
 {
 	switch (tcode) {
 	case TCODE_WRITE_QUADLET_REQUEST:
-		pr_debug("tgt_agent AGENT_RESET\n");
+		target_debug("tgt_agent AGENT_RESET\n");
 		spin_lock_bh(&agent->lock);
 		agent->state = AGENT_STATE_RESET;
 		spin_unlock_bh(&agent->lock);
@@ -718,7 +715,7 @@ static int tgt_agent_rw_orb_pointer(struct fw_card *card, int tcode, void *data,
 		if (agent->state != AGENT_STATE_SUSPENDED &&
 				agent->state != AGENT_STATE_RESET) {
 			spin_unlock_bh(&agent->lock);
-			pr_notice("Ignoring ORB_POINTER write while active.\n");
+			target_notice("Ignoring ORB_POINTER write while active.\n");
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
@@ -727,15 +724,14 @@ static int tgt_agent_rw_orb_pointer(struct fw_card *card, int tcode, void *data,
 		agent->orb_pointer = sbp2_pointer_to_addr(ptr);
 		agent->doorbell = false;
 
-		pr_debug("tgt_agent ORB_POINTER write: 0x%llx\n",
-				agent->orb_pointer);
+		target_debug("tgt_agent ORB_POINTER write: 0x%llx\n", agent->orb_pointer);
 
 		queue_work(system_unbound_wq, &agent->work);
 
 		return RCODE_COMPLETE;
 
 	case TCODE_READ_BLOCK_REQUEST:
-		pr_debug("tgt_agent ORB_POINTER READ\n");
+		target_debug("tgt_agent ORB_POINTER READ\n");
 		spin_lock_bh(&agent->lock);
 		addr_to_sbp2_pointer(agent->orb_pointer, ptr);
 		spin_unlock_bh(&agent->lock);
@@ -754,7 +750,7 @@ static int tgt_agent_rw_doorbell(struct fw_card *card, int tcode, void *data,
 		spin_lock_bh(&agent->lock);
 		if (agent->state != AGENT_STATE_SUSPENDED) {
 			spin_unlock_bh(&agent->lock);
-			pr_debug("Ignoring DOORBELL while active.\n");
+			target_debug("Ignoring DOORBELL while active.\n");
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
@@ -762,7 +758,7 @@ static int tgt_agent_rw_doorbell(struct fw_card *card, int tcode, void *data,
 
 		agent->doorbell = true;
 
-		pr_debug("tgt_agent DOORBELL\n");
+		target_debug("tgt_agent DOORBELL\n");
 
 		queue_work(system_unbound_wq, &agent->work);
 
@@ -781,7 +777,7 @@ static int tgt_agent_rw_unsolicited_status_enable(struct fw_card *card,
 {
 	switch (tcode) {
 	case TCODE_WRITE_QUADLET_REQUEST:
-		pr_debug("tgt_agent UNSOLICITED_STATUS_ENABLE\n");
+		target_debug("tgt_agent UNSOLICITED_STATUS_ENABLE\n");
 		/* ignored as we don't send unsolicited status */
 		return RCODE_COMPLETE;
 
@@ -808,14 +804,13 @@ static void tgt_agent_rw(struct fw_card *card, struct fw_request *request,
 	spin_unlock_bh(&sess->lock);
 
 	if (generation != sess_gen) {
-		pr_notice("ignoring request with wrong generation\n");
+		target_notice("ignoring request with wrong generation\n");
 		rcode = RCODE_TYPE_ERROR;
 		goto out;
 	}
 
 	if (source != sess_node) {
-		pr_notice("ignoring request from foreign node (%x != %x)\n",
-				source, sess_node);
+		target_notice("ignoring request from foreign node (%x != %x)\n", source, sess_node);
 		rcode = RCODE_TYPE_ERROR;
 		goto out;
 	}
@@ -856,14 +851,12 @@ static void tgt_agent_process_work(struct work_struct *work)
 	struct sbp_target_request *req =
 		container_of(work, struct sbp_target_request, work);
 
-	pr_debug("tgt_orb ptr:0x%llx next_ORB:0x%llx data_descriptor:0x%llx misc:0x%x\n",
-			req->orb_pointer,
-			sbp2_pointer_to_addr(&req->orb.next_orb),
-			sbp2_pointer_to_addr(&req->orb.data_descriptor),
-			be32_to_cpu(req->orb.misc));
+	target_debug("tgt_orb ptr:0x%llx next_ORB:0x%llx data_descriptor:0x%llx misc:0x%x\n",
+		     req->orb_pointer, sbp2_pointer_to_addr(&req->orb.next_orb),
+		     sbp2_pointer_to_addr(&req->orb.data_descriptor), be32_to_cpu(req->orb.misc));
 
 	if (req->orb_pointer >> 32)
-		pr_debug("ORB with high bits set\n");
+		target_debug("ORB with high bits set\n");
 
 	switch (ORB_REQUEST_FORMAT(be32_to_cpu(req->orb.misc))) {
 		case 0:/* Format specified by this standard */
@@ -959,7 +952,7 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 				sess->node_id, sess->generation, sess->speed,
 				req->orb_pointer, &req->orb, sizeof(req->orb));
 		if (ret != RCODE_COMPLETE) {
-			pr_debug("tgt_orb fetch failed: %x\n", ret);
+			target_debug("tgt_orb fetch failed: %x\n", ret);
 			req->status.status |= cpu_to_be32(
 					STATUS_BLOCK_SRC(
 						STATUS_SRC_ORB_FINISHED) |
@@ -1120,7 +1113,7 @@ static int sbp_fetch_command(struct sbp_target_request *req)
 		min_t(int, cmd_len, sizeof(req->orb.command_block)));
 
 	if (cmd_len > sizeof(req->orb.command_block)) {
-		pr_debug("sbp_fetch_command: filling in long command\n");
+		target_debug("sbp_fetch_command: filling in long command\n");
 		copy_len = cmd_len - sizeof(req->orb.command_block);
 
 		ret = sbp_run_request_transaction(req,
@@ -1199,22 +1192,21 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	ret = sbp_fetch_command(req);
 	if (ret) {
-		pr_debug("sbp_handle_command: fetch command failed: %d\n", ret);
+		target_debug("sbp_handle_command: fetch command failed: %d\n", ret);
 		goto err;
 	}
 
 	ret = sbp_fetch_page_table(req);
 	if (ret) {
-		pr_debug("sbp_handle_command: fetch page table failed: %d\n",
-			ret);
+		target_debug("sbp_handle_command: fetch page table failed: %d\n", ret);
 		goto err;
 	}
 
 	unpacked_lun = req->login->login_lun;
 	sbp_calc_data_length_direction(req, &data_length, &data_dir);
 
-	pr_debug("sbp_handle_command ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n",
-			req->orb_pointer, unpacked_lun, data_length, data_dir);
+	target_debug("sbp_handle_command ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n",
+		     req->orb_pointer, unpacked_lun, data_length, data_dir);
 
 	/* only used for printk until we do TMRs */
 	req->se_cmd.tag = req->orb_pointer;
@@ -1260,7 +1252,7 @@ static int sbp_rw_data(struct sbp_target_request *req)
 
 	pg_size = CMDBLK_ORB_PG_SIZE(be32_to_cpu(req->orb.misc));
 	if (pg_size) {
-		pr_err("sbp_run_transaction: page size ignored\n");
+		target_err("sbp_run_transaction: page size ignored\n");
 	}
 
 	spin_lock_bh(&sess->lock);
@@ -1335,13 +1327,12 @@ static int sbp_send_status(struct sbp_target_request *req)
 	rc = sbp_run_request_transaction(req, TCODE_WRITE_BLOCK_REQUEST,
 			login->status_fifo_addr, &req->status, length);
 	if (rc != RCODE_COMPLETE) {
-		pr_debug("sbp_send_status: write failed: 0x%x\n", rc);
+		target_debug("sbp_send_status: write failed: 0x%x\n", rc);
 		ret = -EIO;
 		goto put_ref;
 	}
 
-	pr_debug("sbp_send_status: status write complete for ORB: 0x%llx\n",
-			req->orb_pointer);
+	target_debug("sbp_send_status: status write complete for ORB: 0x%llx\n", req->orb_pointer);
 	/*
 	 * Drop the extra ACK_KREF reference taken by target_submit_cmd()
 	 * ahead of sbp_check_stop_free() -> transport_generic_free_cmd()
@@ -1374,8 +1365,7 @@ static void sbp_sense_mangle(struct sbp_target_request *req)
 		 * TODO: SBP-3 specifies what we should do with descriptor
 		 * format sense data
 		 */
-		pr_err("sbp_send_sense: unknown sense format: 0x%x\n",
-			sense[0]);
+		target_err("sbp_send_sense: unknown sense format: 0x%x\n", sense[0]);
 		req->status.status |= cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
 			STATUS_BLOCK_DEAD(0) |
@@ -1460,19 +1450,18 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		req->node_addr, req->generation, req->speed,
 		agent->orb_offset, &req->orb, sizeof(req->orb));
 	if (ret != RCODE_COMPLETE) {
-		pr_debug("mgt_orb fetch failed: %x\n", ret);
+		target_debug("mgt_orb fetch failed: %x\n", ret);
 		goto out;
 	}
 
-	pr_debug("mgt_orb ptr1:0x%llx ptr2:0x%llx misc:0x%x len:0x%x status_fifo:0x%llx\n",
-		sbp2_pointer_to_addr(&req->orb.ptr1),
-		sbp2_pointer_to_addr(&req->orb.ptr2),
-		be32_to_cpu(req->orb.misc), be32_to_cpu(req->orb.length),
-		sbp2_pointer_to_addr(&req->orb.status_fifo));
+	target_debug("mgt_orb ptr1:0x%llx ptr2:0x%llx misc:0x%x len:0x%x status_fifo:0x%llx\n",
+		     sbp2_pointer_to_addr(&req->orb.ptr1), sbp2_pointer_to_addr(&req->orb.ptr2),
+		     be32_to_cpu(req->orb.misc), be32_to_cpu(req->orb.length),
+		     sbp2_pointer_to_addr(&req->orb.status_fifo));
 
 	if (!ORB_NOTIFY(be32_to_cpu(req->orb.misc)) ||
 		ORB_REQUEST_FORMAT(be32_to_cpu(req->orb.misc)) != 0) {
-		pr_err("mgt_orb bad request\n");
+		target_err("mgt_orb bad request\n");
 		goto out;
 	}
 
@@ -1491,7 +1480,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	case MANAGEMENT_ORB_FUNCTION_SET_PASSWORD:
-		pr_notice("SET PASSWORD not implemented\n");
+		target_notice("SET PASSWORD not implemented\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1504,7 +1493,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	case MANAGEMENT_ORB_FUNCTION_ABORT_TASK:
-		pr_notice("ABORT TASK not implemented\n");
+		target_notice("ABORT TASK not implemented\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1513,7 +1502,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	case MANAGEMENT_ORB_FUNCTION_ABORT_TASK_SET:
-		pr_notice("ABORT TASK SET not implemented\n");
+		target_notice("ABORT TASK SET not implemented\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1522,7 +1511,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	case MANAGEMENT_ORB_FUNCTION_LOGICAL_UNIT_RESET:
-		pr_notice("LOGICAL UNIT RESET not implemented\n");
+		target_notice("LOGICAL UNIT RESET not implemented\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1531,7 +1520,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	case MANAGEMENT_ORB_FUNCTION_TARGET_RESET:
-		pr_notice("TARGET RESET not implemented\n");
+		target_notice("TARGET RESET not implemented\n");
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1540,8 +1529,8 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		break;
 
 	default:
-		pr_notice("unknown management function 0x%x\n",
-			MANAGEMENT_ORB_FUNCTION(be32_to_cpu(req->orb.misc)));
+		target_notice("unknown management function 0x%x\n",
+			      MANAGEMENT_ORB_FUNCTION(be32_to_cpu(req->orb.misc)));
 
 		req->status.status = cpu_to_be32(
 			STATUS_BLOCK_RESP(STATUS_RESP_REQUEST_COMPLETE) |
@@ -1562,7 +1551,7 @@ static void sbp_mgt_agent_process(struct work_struct *work)
 		sbp2_pointer_to_addr(&req->orb.status_fifo),
 		&req->status, 8 + status_data_len);
 	if (ret != RCODE_COMPLETE) {
-		pr_debug("mgt_orb status write failed: %x\n", ret);
+		target_debug("mgt_orb status write failed: %x\n", ret);
 		goto out;
 	}
 
@@ -1600,7 +1589,7 @@ static void sbp_mgt_agent_rw(struct fw_card *card,
 		spin_unlock_bh(&agent->lock);
 
 		if (prev_state == MANAGEMENT_AGENT_STATE_BUSY) {
-			pr_notice("ignoring management request while busy\n");
+			target_notice("ignoring management request while busy\n");
 			rcode = RCODE_CONFLICT_ERROR;
 			goto out;
 		}
@@ -1910,8 +1899,7 @@ static ssize_t sbp_parse_wwn(const char *name, u64 *wwn)
 	}
 	err = 4;
 fail:
-	printk(KERN_INFO "err %u len %zu pos %u\n",
-			err, cp - name, pos);
+	target_info("err %u len %zu pos %u\n", err, cp - name, pos);
 	return -1;
 }
 
@@ -1951,7 +1939,7 @@ static void sbp_pre_unlink_lun(
 
 	ret = sbp_update_unit_directory(tport);
 	if (ret < 0)
-		pr_err("unlink LUN: failed to update unit directory\n");
+		target_err("unlink LUN: failed to update unit directory\n");
 }
 
 static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
@@ -1970,7 +1958,7 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
-		pr_err("Only one TPG per Unit is possible.\n");
+		target_err("Only one TPG per Unit is possible.\n");
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -2082,7 +2070,7 @@ static ssize_t sbp_tpg_directory_id_store(struct config_item *item,
 	unsigned long val;
 
 	if (tport->enable) {
-		pr_err("Cannot change the directory_id on an active target.\n");
+		target_err("Cannot change the directory_id on an active target.\n");
 		return -EBUSY;
 	}
 
@@ -2108,7 +2096,7 @@ static int sbp_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 
 	if (enable) {
 		if (sbp_count_se_tpg_luns(&tpg->se_tpg) == 0) {
-			pr_err("Cannot enable a target with no LUNs!\n");
+			target_err("Cannot enable a target with no LUNs!\n");
 			return -EINVAL;
 		}
 	} else {
@@ -2125,7 +2113,7 @@ static int sbp_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 
 	ret = sbp_update_unit_directory(tport);
 	if (ret < 0) {
-		pr_err("Could not update Config ROM\n");
+		target_err("Could not update Config ROM\n");
 		return ret;
 	}
 
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 01751faad386..a5906012c369 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -62,8 +62,9 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	u32 rd_len = 0, off;
 
 	if (cmd->data_length < 4) {
-		pr_warn("REPORT REFERRALS allocation length %u too"
-			" small\n", cmd->data_length);
+		target_warn("REPORT REFERRALS allocation length %u too"
+			    " small\n",
+			    cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -152,9 +153,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		off = 4;
 
 	if (cmd->data_length < off) {
-		pr_warn("REPORT TARGET PORT GROUPS allocation length %u too"
-			" small for %s header\n", cmd->data_length,
-			(ext_hdr) ? "extended" : "normal");
+		target_warn("REPORT TARGET PORT GROUPS allocation length %u too"
+			    " small for %s header\n",
+			    cmd->data_length, (ext_hdr) ? "extended" : "normal");
 		return TCM_INVALID_CDB_FIELD;
 	}
 	buf = transport_kmap_data_sg(cmd);
@@ -282,8 +283,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	u16 tg_pt_id, rtpi;
 
 	if (cmd->data_length < 4) {
-		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			" small\n", cmd->data_length);
+		target_warn("SET TARGET PORT GROUPS parameter list length %u too"
+			    " small\n",
+			    cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -299,15 +301,15 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	l_tg_pt_gp = rcu_dereference(l_lun->lun_tg_pt_gp);
 	if (!l_tg_pt_gp) {
 		rcu_read_unlock();
-		pr_err("Unable to access l_lun->tg_pt_gp\n");
+		target_err("Unable to access l_lun->tg_pt_gp\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
 
 	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
 		rcu_read_unlock();
-		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
-				" while TPGS_EXPLICIT_ALUA is disabled\n");
+		target_debug("Unable to process SET_TARGET_PORT_GROUPS"
+			     " while TPGS_EXPLICIT_ALUA is disabled\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
@@ -661,8 +663,8 @@ target_alua_state_check(struct se_cmd *cmd)
 	 * access state: OFFLINE
 	 */
 	if (atomic_read(&lun->lun_tg_pt_secondary_offline)) {
-		pr_debug("ALUA: Got secondary offline status for local"
-				" target port\n");
+		target_debug("ALUA: Got secondary offline status for local"
+			     " target port\n");
 		return TCM_ALUA_OFFLINE;
 	}
 	rcu_read_lock();
@@ -707,15 +709,14 @@ target_alua_state_check(struct se_cmd *cmd)
 	 */
 	case ALUA_ACCESS_STATE_OFFLINE:
 	default:
-		pr_err("Unknown ALUA access state: 0x%02x\n",
-				out_alua_state);
+		target_err("Unknown ALUA access state: 0x%02x\n", out_alua_state);
 		rc = TCM_INVALID_CDB_FIELD;
 	}
 
 	if (rc && rc != TCM_INVALID_CDB_FIELD) {
-		pr_debug("[%s]: ALUA TG Port not available, "
-			"SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
-			cmd->se_tfo->fabric_name, rc);
+		target_debug("[%s]: ALUA TG Port not available, "
+			     "SenseKey: NOT_READY, ASC/rc: 0x04/%d\n",
+			     cmd->se_tfo->fabric_name, rc);
 	}
 
 	return rc;
@@ -776,15 +777,14 @@ core_alua_check_transition(int state, int valid, int *primary, int explicit)
 		*primary = 0;
 		break;
 	default:
-		pr_err("Unknown ALUA access state: 0x%02x\n", state);
+		target_err("Unknown ALUA access state: 0x%02x\n", state);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
 	return 0;
 
 not_supported:
-	pr_err("ALUA access state %s not supported",
-	       core_alua_dump_state(state));
+	target_err("ALUA access state %s not supported", core_alua_dump_state(state));
 	return TCM_INVALID_PARAMETER_LIST;
 }
 
@@ -861,12 +861,12 @@ static int core_alua_write_tpg_metadata(
 	int ret;
 
 	if (IS_ERR(file)) {
-		pr_err("filp_open(%s) for ALUA metadata failed\n", path);
+		target_err("filp_open(%s) for ALUA metadata failed\n", path);
 		return -ENODEV;
 	}
 	ret = kernel_write(file, md_buf, md_buf_len, &pos);
 	if (ret < 0)
-		pr_err("Error writing ALUA metadata file: %s\n", path);
+		target_err("Error writing ALUA metadata file: %s\n", path);
 	fput(file);
 	return (ret < 0) ? -EIO : 0;
 }
@@ -883,7 +883,7 @@ static int core_alua_update_tpg_primary_metadata(
 
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
-		pr_err("Unable to allocate buf for ALUA metadata\n");
+		target_err("Unable to allocate buf for ALUA metadata\n");
 		return -ENOMEM;
 	}
 
@@ -1036,12 +1036,11 @@ static int core_alua_do_transition_tg_pt(
 		core_alua_update_tpg_primary_metadata(tg_pt_gp);
 	}
 
-	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		" from primary access state %s to %s\n", (explicit) ? "explicit" :
-		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
-		tg_pt_gp->tg_pt_gp_id,
-		core_alua_dump_state(prev_state),
-		core_alua_dump_state(new_state));
+	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
+		     " from primary access state %s to %s\n",
+		     (explicit) ? "explicit" : "implicit",
+		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
+		     core_alua_dump_state(prev_state), core_alua_dump_state(new_state));
 
 	core_alua_queue_state_change_ua(tg_pt_gp);
 
@@ -1153,12 +1152,10 @@ int core_alua_do_port_transition(
 	spin_unlock(&lu_gp->lu_gp_lock);
 
 	if (!rc) {
-		pr_debug("Successfully processed LU Group: %s all ALUA TG PT"
-			 " Group IDs: %hu %s transition to primary state: %s\n",
-			 config_item_name(&lu_gp->lu_gp_group.cg_item),
-			 l_tg_pt_gp->tg_pt_gp_id,
-			 (explicit) ? "explicit" : "implicit",
-			 core_alua_dump_state(new_state));
+		target_debug("Successfully processed LU Group: %s all ALUA TG PT"
+			     " Group IDs: %hu %s transition to primary state: %s\n",
+			     config_item_name(&lu_gp->lu_gp_group.cg_item), l_tg_pt_gp->tg_pt_gp_id,
+			     (explicit) ? "explicit" : "implicit", core_alua_dump_state(new_state));
 	}
 
 	atomic_dec_mb(&lu_gp->lu_gp_ref_cnt);
@@ -1176,7 +1173,7 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
-		pr_err("Unable to allocate buf for ALUA metadata\n");
+		target_err("Unable to allocate buf for ALUA metadata\n");
 		rc = -ENOMEM;
 		goto out_unlock;
 	}
@@ -1224,8 +1221,8 @@ static int core_alua_set_tg_pt_secondary_state(
 	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (!tg_pt_gp) {
 		rcu_read_unlock();
-		pr_err("Unable to complete secondary state"
-				" transition\n");
+		target_err("Unable to complete secondary state"
+			   " transition\n");
 		return -EINVAL;
 	}
 	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
@@ -1242,10 +1239,11 @@ static int core_alua_set_tg_pt_secondary_state(
 			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
-	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
-		" to secondary access state: %s\n", (explicit) ? "explicit" :
-		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
-		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
+	target_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
+		     " to secondary access state: %s\n",
+		     (explicit) ? "explicit" : "implicit",
+		     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item), tg_pt_gp->tg_pt_gp_id,
+		     (offline) ? "OFFLINE" : "ONLINE");
 
 	rcu_read_unlock();
 	/*
@@ -1272,7 +1270,7 @@ core_alua_allocate_lba_map(struct list_head *list,
 
 	lba_map = kmem_cache_zalloc(t10_alua_lba_map_cache, GFP_KERNEL);
 	if (!lba_map) {
-		pr_err("Unable to allocate struct t10_alua_lba_map\n");
+		target_err("Unable to allocate struct t10_alua_lba_map\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lba_map->lba_map_mem_list);
@@ -1292,14 +1290,14 @@ core_alua_allocate_lba_map_mem(struct t10_alua_lba_map *lba_map,
 	list_for_each_entry(lba_map_mem, &lba_map->lba_map_mem_list,
 			    lba_map_mem_list) {
 		if (lba_map_mem->lba_map_mem_alua_pg_id == pg_id) {
-			pr_err("Duplicate pg_id %d in lba_map\n", pg_id);
+			target_err("Duplicate pg_id %d in lba_map\n", pg_id);
 			return -EINVAL;
 		}
 	}
 
 	lba_map_mem = kmem_cache_zalloc(t10_alua_lba_map_mem_cache, GFP_KERNEL);
 	if (!lba_map_mem) {
-		pr_err("Unable to allocate struct t10_alua_lba_map_mem\n");
+		target_err("Unable to allocate struct t10_alua_lba_map_mem\n");
 		return -ENOMEM;
 	}
 	lba_map_mem->lba_map_mem_alua_state = state;
@@ -1372,7 +1370,7 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 
 	lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL);
 	if (!lu_gp) {
-		pr_err("Unable to allocate struct t10_alua_lu_gp\n");
+		target_err("Unable to allocate struct t10_alua_lu_gp\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
@@ -1397,15 +1395,15 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 	 * The lu_gp->lu_gp_id may only be set once..
 	 */
 	if (lu_gp->lu_gp_valid_id) {
-		pr_warn("ALUA LU Group already has a valid ID,"
-			" ignoring request\n");
+		target_warn("ALUA LU Group already has a valid ID,"
+			    " ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&lu_gps_lock);
 	if (alua_lu_gps_count == 0x0000ffff) {
-		pr_err("Maximum ALUA alua_lu_gps_count:"
-				" 0x0000ffff reached\n");
+		target_err("Maximum ALUA alua_lu_gps_count:"
+			   " 0x0000ffff reached\n");
 		spin_unlock(&lu_gps_lock);
 		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
 		return -ENOSPC;
@@ -1419,9 +1417,9 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 			if (!lu_gp_id)
 				goto again;
 
-			pr_warn("ALUA Logical Unit Group ID: %hu"
-				" already exists, ignoring request\n",
-				lu_gp_id);
+			target_warn("ALUA Logical Unit Group ID: %hu"
+				    " already exists, ignoring request\n",
+				    lu_gp_id);
 			spin_unlock(&lu_gps_lock);
 			return -EINVAL;
 		}
@@ -1443,7 +1441,7 @@ core_alua_allocate_lu_gp_mem(struct se_device *dev)
 
 	lu_gp_mem = kmem_cache_zalloc(t10_alua_lu_gp_mem_cache, GFP_KERNEL);
 	if (!lu_gp_mem) {
-		pr_err("Unable to allocate struct t10_alua_lu_gp_member\n");
+		target_err("Unable to allocate struct t10_alua_lu_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_list);
@@ -1609,7 +1607,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 
 	tg_pt_gp = kmem_cache_zalloc(t10_alua_tg_pt_gp_cache, GFP_KERNEL);
 	if (!tg_pt_gp) {
-		pr_err("Unable to allocate struct t10_alua_tg_pt_gp\n");
+		target_err("Unable to allocate struct t10_alua_tg_pt_gp\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
@@ -1665,15 +1663,15 @@ int core_alua_set_tg_pt_gp_id(
 	 * The tg_pt_gp->tg_pt_gp_id may only be set once..
 	 */
 	if (tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_warn("ALUA TG PT Group already has a valid ID,"
-			" ignoring request\n");
+		target_warn("ALUA TG PT Group already has a valid ID,"
+			    " ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	if (dev->t10_alua.alua_tg_pt_gps_count == 0x0000ffff) {
-		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
-			" 0x0000ffff reached\n");
+		target_err("Maximum ALUA alua_tg_pt_gps_count:"
+			   " 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 		return -ENOSPC;
 	}
@@ -1687,8 +1685,9 @@ int core_alua_set_tg_pt_gp_id(
 			if (!tg_pt_gp_id)
 				goto again;
 
-			pr_err("ALUA Target Port Group ID: %hu already"
-				" exists, ignoring request\n", tg_pt_gp_id);
+			target_err("ALUA Target Port Group ID: %hu already"
+				   " exists, ignoring request\n",
+				   tg_pt_gp_id);
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 			return -EINVAL;
 		}
@@ -1912,7 +1911,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		return -ENODEV;
 
 	if (count > TG_PT_GROUP_NAME_BUF) {
-		pr_err("ALUA Target Port Group alias too large!\n");
+		target_err("ALUA Target Port Group alias too large!\n");
 		return -EINVAL;
 	}
 	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
@@ -1942,16 +1941,15 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!tg_pt_gp_new) {
-			pr_debug("Target_Core_ConfigFS: Moving"
-				" %s/tpgt_%hu/%s from ALUA Target Port Group:"
-				" alua/%s, ID: %hu back to"
-				" default_tg_pt_gp\n",
-				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-				tpg->se_tpg_tfo->tpg_get_tag(tpg),
-				config_item_name(&lun->lun_group.cg_item),
-				config_item_name(
-					&tg_pt_gp->tg_pt_gp_group.cg_item),
-				tg_pt_gp->tg_pt_gp_id);
+			target_debug("Target_Core_ConfigFS: Moving"
+				     " %s/tpgt_%hu/%s from ALUA Target Port Group:"
+				     " alua/%s, ID: %hu back to"
+				     " default_tg_pt_gp\n",
+				     tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+				     tpg->se_tpg_tfo->tpg_get_tag(tpg),
+				     config_item_name(&lun->lun_group.cg_item),
+				     config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+				     tg_pt_gp->tg_pt_gp_id);
 
 			target_swap_tg_pt_gp(lun, tg_pt_gp,
 					dev->t10_alua.default_tg_pt_gp);
@@ -1964,13 +1962,12 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	pr_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
-		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
-		"Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		config_item_name(&lun->lun_group.cg_item),
-		config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
-		tg_pt_gp_new->tg_pt_gp_id);
+	target_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
+		     " Target Port Group: alua/%s, ID: %hu\n",
+		     (move) ? "Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+		     tpg->se_tpg_tfo->tpg_get_tag(tpg), config_item_name(&lun->lun_group.cg_item),
+		     config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
+		     tg_pt_gp_new->tg_pt_gp_id);
 
 	core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
 sync_rcu:
@@ -2003,12 +2000,13 @@ ssize_t core_alua_store_access_type(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract alua_access_type\n");
+		target_err("Unable to extract alua_access_type\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
-		pr_err("Illegal value for alua_access_type:"
-				" %lu\n", tmp);
+		target_err("Illegal value for alua_access_type:"
+			   " %lu\n",
+			   tmp);
 		return -EINVAL;
 	}
 	if (tmp == 3)
@@ -2041,13 +2039,13 @@ ssize_t core_alua_store_nonop_delay_msecs(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract nonop_delay_msecs\n");
+		target_err("Unable to extract nonop_delay_msecs\n");
 		return ret;
 	}
 	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
-		pr_err("Passed nonop_delay_msecs: %lu, exceeds"
-			" ALUA_MAX_NONOP_DELAY_MSECS: %d\n", tmp,
-			ALUA_MAX_NONOP_DELAY_MSECS);
+		target_err("Passed nonop_delay_msecs: %lu, exceeds"
+			   " ALUA_MAX_NONOP_DELAY_MSECS: %d\n",
+			   tmp, ALUA_MAX_NONOP_DELAY_MSECS);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_nonop_delay_msecs = (int)tmp;
@@ -2072,13 +2070,13 @@ ssize_t core_alua_store_trans_delay_msecs(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract trans_delay_msecs\n");
+		target_err("Unable to extract trans_delay_msecs\n");
 		return ret;
 	}
 	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
-		pr_err("Passed trans_delay_msecs: %lu, exceeds"
-			" ALUA_MAX_TRANS_DELAY_MSECS: %d\n", tmp,
-			ALUA_MAX_TRANS_DELAY_MSECS);
+		target_err("Passed trans_delay_msecs: %lu, exceeds"
+			   " ALUA_MAX_TRANS_DELAY_MSECS: %d\n",
+			   tmp, ALUA_MAX_TRANS_DELAY_MSECS);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_trans_delay_msecs = (int)tmp;
@@ -2103,13 +2101,13 @@ ssize_t core_alua_store_implicit_trans_secs(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract implicit_trans_secs\n");
+		target_err("Unable to extract implicit_trans_secs\n");
 		return ret;
 	}
 	if (tmp > ALUA_MAX_IMPLICIT_TRANS_SECS) {
-		pr_err("Passed implicit_trans_secs: %lu, exceeds"
-			" ALUA_MAX_IMPLICIT_TRANS_SECS: %d\n", tmp,
-			ALUA_MAX_IMPLICIT_TRANS_SECS);
+		target_err("Passed implicit_trans_secs: %lu, exceeds"
+			   " ALUA_MAX_IMPLICIT_TRANS_SECS: %d\n",
+			   tmp, ALUA_MAX_IMPLICIT_TRANS_SECS);
 		return  -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_implicit_trans_secs = (int)tmp;
@@ -2134,11 +2132,11 @@ ssize_t core_alua_store_preferred_bit(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract preferred ALUA value\n");
+		target_err("Unable to extract preferred ALUA value\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		pr_err("Illegal value for preferred ALUA: %lu\n", tmp);
+		target_err("Illegal value for preferred ALUA: %lu\n", tmp);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_pref = (int)tmp;
@@ -2171,12 +2169,11 @@ ssize_t core_alua_store_offline_bit(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract alua_tg_pt_offline value\n");
+		target_err("Unable to extract alua_tg_pt_offline value\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		pr_err("Illegal value for alua_tg_pt_offline: %lu\n",
-				tmp);
+		target_err("Illegal value for alua_tg_pt_offline: %lu\n", tmp);
 		return -EINVAL;
 	}
 
@@ -2204,14 +2201,13 @@ ssize_t core_alua_store_secondary_status(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract alua_tg_pt_status\n");
+		target_err("Unable to extract alua_tg_pt_status\n");
 		return ret;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA)) {
-		pr_err("Illegal value for alua_tg_pt_status: %lu\n",
-				tmp);
+		target_err("Illegal value for alua_tg_pt_status: %lu\n", tmp);
 		return -EINVAL;
 	}
 	lun->lun_tg_pt_secondary_stat = (int)tmp;
@@ -2236,12 +2232,13 @@ ssize_t core_alua_store_secondary_write_metadata(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract alua_tg_pt_write_md\n");
+		target_err("Unable to extract alua_tg_pt_write_md\n");
 		return ret;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		pr_err("Illegal value for alua_tg_pt_write_md:"
-				" %lu\n", tmp);
+		target_err("Illegal value for alua_tg_pt_write_md:"
+			   " %lu\n",
+			   tmp);
 		return -EINVAL;
 	}
 	lun->lun_tg_pt_secondary_write_md = (int)tmp;
@@ -2269,9 +2266,9 @@ int core_setup_alua(struct se_device *dev)
 				default_lu_gp);
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-		pr_debug("%s: Adding to default ALUA LU Group:"
-			" core/alua/lu_gps/default_lu_gp\n",
-			dev->transport->name);
+		target_debug("%s: Adding to default ALUA LU Group:"
+			     " core/alua/lu_gps/default_lu_gp\n",
+			     dev->transport->name);
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..081521f8eb1a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -49,7 +49,7 @@ static void target_core_setup_##_name##_cit(struct target_backend *tb)	\
 	cit->ct_group_ops = _group_ops;					\
 	cit->ct_attrs = _attrs;						\
 	cit->ct_owner = tb->ops->owner;					\
-	pr_debug("Setup generic %s\n", __stringify(_name));		\
+	target_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
 #define TB_CIT_SETUP_DRV(_name, _item_ops, _group_ops)			\
@@ -61,7 +61,7 @@ static void target_core_setup_##_name##_cit(struct target_backend *tb)	\
 	cit->ct_group_ops = _group_ops;					\
 	cit->ct_attrs = tb->ops->tb_##_name##_attrs;			\
 	cit->ct_owner = tb->ops->owner;					\
-	pr_debug("Setup generic %s\n", __stringify(_name));		\
+	target_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
 extern struct t10_alua_lu_gp *default_lu_gp;
@@ -113,13 +113,13 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 
 	mutex_lock(&target_devices_lock);
 	if (target_devices) {
-		pr_err("db_root: cannot be changed because it's in use\n");
+		target_err("db_root: cannot be changed because it's in use\n");
 		goto unlock;
 	}
 
 	if (count > (DB_ROOT_LEN - 1)) {
-		pr_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n",
-		       (int)count, DB_ROOT_LEN - 1);
+		target_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n", (int)count,
+			   DB_ROOT_LEN - 1);
 		goto unlock;
 	}
 
@@ -133,18 +133,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	/* validate new db root before accepting it */
 	fp = filp_open(db_root_stage, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
-		pr_err("db_root: cannot open: %s\n", db_root_stage);
+		target_err("db_root: cannot open: %s\n", db_root_stage);
 		goto unlock;
 	}
 	if (!S_ISDIR(file_inode(fp)->i_mode)) {
 		filp_close(fp, NULL);
-		pr_err("db_root: not a directory: %s\n", db_root_stage);
+		target_err("db_root: not a directory: %s\n", db_root_stage);
 		goto unlock;
 	}
 	filp_close(fp, NULL);
 
 	strncpy(db_root, db_root_stage, read_bytes);
-	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+	target_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
 
@@ -189,13 +189,13 @@ static struct config_group *target_core_register_fabric(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	pr_debug("Target_Core_ConfigFS: REGISTER -> group: %p name:"
-			" %s\n", group, name);
+	target_debug("Target_Core_ConfigFS: REGISTER -> group: %p name:"
+		     " %s\n",
+		     group, name);
 
 	tf = target_core_get_fabric(name);
 	if (!tf) {
-		pr_debug("target_core_register_fabric() trying autoload for %s\n",
-			 name);
+		target_debug("target_core_register_fabric() trying autoload for %s\n", name);
 
 		/*
 		 * Below are some hardcoded request_module() calls to automatically
@@ -217,8 +217,9 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("iscsi_target_mod");
 			if (ret < 0) {
-				pr_debug("request_module() failed for"
-				         " iscsi_target_mod.ko: %d\n", ret);
+				target_debug("request_module() failed for"
+					     " iscsi_target_mod.ko: %d\n",
+					     ret);
 				return ERR_PTR(-EINVAL);
 			}
 		} else if (!strncmp(name, "loopback", 8)) {
@@ -230,8 +231,9 @@ static struct config_group *target_core_register_fabric(
 			 */
 			ret = request_module("tcm_loop");
 			if (ret < 0) {
-				pr_debug("request_module() failed for"
-				         " tcm_loop.ko: %d\n", ret);
+				target_debug("request_module() failed for"
+					     " tcm_loop.ko: %d\n",
+					     ret);
 				return ERR_PTR(-EINVAL);
 			}
 		}
@@ -240,18 +242,17 @@ static struct config_group *target_core_register_fabric(
 	}
 
 	if (!tf) {
-		pr_debug("target_core_get_fabric() failed for %s\n",
-		         name);
+		target_debug("target_core_get_fabric() failed for %s\n", name);
 		return ERR_PTR(-EINVAL);
 	}
-	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
-			" %s\n", tf->tf_ops->fabric_name);
+	target_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
+		     " %s\n",
+		     tf->tf_ops->fabric_name);
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
 	 */
-	pr_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
-			&tf->tf_wwn_cit);
+	target_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n", &tf->tf_wwn_cit);
 
 	config_group_init_type_name(&tf->tf_group, name, &tf->tf_wwn_cit);
 
@@ -259,8 +260,8 @@ static struct config_group *target_core_register_fabric(
 			&tf->tf_discovery_cit);
 	configfs_add_default_group(&tf->tf_disc_group, &tf->tf_group);
 
-	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
-		 config_item_name(&tf->tf_group.cg_item));
+	target_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
+		     config_item_name(&tf->tf_group.cg_item));
 	return &tf->tf_group;
 }
 
@@ -274,15 +275,18 @@ static void target_core_deregister_fabric(
 	struct target_fabric_configfs *tf = container_of(
 		to_config_group(item), struct target_fabric_configfs, tf_group);
 
-	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
-		" tf list\n", config_item_name(item));
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
+		     " tf list\n",
+		     config_item_name(item));
 
-	pr_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric:"
-			" %s\n", tf->tf_ops->fabric_name);
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric:"
+		     " %s\n",
+		     tf->tf_ops->fabric_name);
 	atomic_dec(&tf->tf_access_cnt);
 
-	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
-			" %s\n", config_item_name(item));
+	target_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
+		     " %s\n",
+		     config_item_name(item));
 
 	configfs_remove_default_groups(&tf->tf_group);
 	config_item_put(item);
@@ -363,54 +367,56 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 {
 	if (tfo->fabric_alias) {
 		if (strlen(tfo->fabric_alias) >= TARGET_FABRIC_NAME_SIZE) {
-			pr_err("Passed alias: %s exceeds "
-				"TARGET_FABRIC_NAME_SIZE\n", tfo->fabric_alias);
+			target_err("Passed alias: %s exceeds "
+				   "TARGET_FABRIC_NAME_SIZE\n",
+				   tfo->fabric_alias);
 			return -EINVAL;
 		}
 	}
 	if (!tfo->fabric_name) {
-		pr_err("Missing tfo->fabric_name\n");
+		target_err("Missing tfo->fabric_name\n");
 		return -EINVAL;
 	}
 	if (strlen(tfo->fabric_name) >= TARGET_FABRIC_NAME_SIZE) {
-		pr_err("Passed name: %s exceeds "
-			"TARGET_FABRIC_NAME_SIZE\n", tfo->fabric_name);
+		target_err("Passed name: %s exceeds "
+			   "TARGET_FABRIC_NAME_SIZE\n",
+			   tfo->fabric_name);
 		return -EINVAL;
 	}
 	if (!tfo->tpg_get_wwn) {
-		pr_err("Missing tfo->tpg_get_wwn()\n");
+		target_err("Missing tfo->tpg_get_wwn()\n");
 		return -EINVAL;
 	}
 	if (!tfo->tpg_get_tag) {
-		pr_err("Missing tfo->tpg_get_tag()\n");
+		target_err("Missing tfo->tpg_get_tag()\n");
 		return -EINVAL;
 	}
 	if (!tfo->release_cmd) {
-		pr_err("Missing tfo->release_cmd()\n");
+		target_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
 	if (!tfo->write_pending) {
-		pr_err("Missing tfo->write_pending()\n");
+		target_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
 	}
 	if (!tfo->queue_data_in) {
-		pr_err("Missing tfo->queue_data_in()\n");
+		target_err("Missing tfo->queue_data_in()\n");
 		return -EINVAL;
 	}
 	if (!tfo->queue_status) {
-		pr_err("Missing tfo->queue_status()\n");
+		target_err("Missing tfo->queue_status()\n");
 		return -EINVAL;
 	}
 	if (!tfo->queue_tm_rsp) {
-		pr_err("Missing tfo->queue_tm_rsp()\n");
+		target_err("Missing tfo->queue_tm_rsp()\n");
 		return -EINVAL;
 	}
 	if (!tfo->aborted_task) {
-		pr_err("Missing tfo->aborted_task()\n");
+		target_err("Missing tfo->aborted_task()\n");
 		return -EINVAL;
 	}
 	if (!tfo->check_stop_free) {
-		pr_err("Missing tfo->check_stop_free()\n");
+		target_err("Missing tfo->check_stop_free()\n");
 		return -EINVAL;
 	}
 	/*
@@ -419,19 +425,19 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 	 * target_core_fabric_configfs.c WWN+TPG group context code.
 	 */
 	if (!tfo->fabric_make_wwn) {
-		pr_err("Missing tfo->fabric_make_wwn()\n");
+		target_err("Missing tfo->fabric_make_wwn()\n");
 		return -EINVAL;
 	}
 	if (!tfo->fabric_drop_wwn) {
-		pr_err("Missing tfo->fabric_drop_wwn()\n");
+		target_err("Missing tfo->fabric_drop_wwn()\n");
 		return -EINVAL;
 	}
 	if (!tfo->fabric_make_tpg) {
-		pr_err("Missing tfo->fabric_make_tpg()\n");
+		target_err("Missing tfo->fabric_make_tpg()\n");
 		return -EINVAL;
 	}
 	if (!tfo->fabric_drop_tpg) {
-		pr_err("Missing tfo->fabric_drop_tpg()\n");
+		target_err("Missing tfo->fabric_drop_tpg()\n");
 		return -EINVAL;
 	}
 
@@ -477,13 +483,13 @@ int target_register_template(const struct target_core_fabric_ops *fo)
 
 	tf = kzalloc(sizeof(struct target_fabric_configfs), GFP_KERNEL);
 	if (!tf) {
-		pr_err("%s: could not allocate memory!\n", __func__);
+		target_err("%s: could not allocate memory!\n", __func__);
 		return -ENOMEM;
 	}
 	tfo = kzalloc(sizeof(struct target_core_fabric_ops), GFP_KERNEL);
 	if (!tfo) {
 		kfree(tf);
-		pr_err("%s: could not allocate memory!\n", __func__);
+		target_err("%s: could not allocate memory!\n", __func__);
 		return -ENOMEM;
 	}
 	memcpy(tfo, fo, sizeof(*tfo));
@@ -641,9 +647,9 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
 
 	configname = config_item_name(&dev->dev_group.cg_item);
 	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
-		pr_warn("dev[%p]: Backstore name '%s' is too long for "
-			"INQUIRY_MODEL, truncating to 15 characters\n", dev,
-			configname);
+		target_warn("dev[%p]: Backstore name '%s' is too long for "
+			    "INQUIRY_MODEL, truncating to 15 characters\n",
+			    dev, configname);
 	}
 	/*
 	 * XXX We can't use sizeof(dev->t10_wwn.model) (INQUIRY_MODEL_LEN + 1)
@@ -662,9 +668,9 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
 	int ret;
 
 	if (dev->export_count) {
-		pr_err("dev[%p]: Unable to change model alias"
-			" while export_count is %d\n",
-			dev, dev->export_count);
+		target_err("dev[%p]: Unable to change model alias"
+			   " while export_count is %d\n",
+			   dev, dev->export_count);
 		return -EINVAL;
 	}
 
@@ -695,13 +701,12 @@ static ssize_t emulate_write_cache_store(struct config_item *item,
 		return ret;
 
 	if (flag && da->da_dev->transport->get_write_cache) {
-		pr_err("emulate_write_cache not supported for this device\n");
+		target_err("emulate_write_cache not supported for this device\n");
 		return -EINVAL;
 	}
 
 	da->emulate_write_cache = flag;
-	pr_debug("dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
-			da->da_dev, flag);
+	target_debug("dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -719,19 +724,18 @@ static ssize_t emulate_ua_intlck_ctrl_store(struct config_item *item,
 	if (val != TARGET_UA_INTLCK_CTRL_CLEAR
 	 && val != TARGET_UA_INTLCK_CTRL_NO_CLEAR
 	 && val != TARGET_UA_INTLCK_CTRL_ESTABLISH_UA) {
-		pr_err("Illegal value %d\n", val);
+		target_err("Illegal value %d\n", val);
 		return -EINVAL;
 	}
 
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device"
-			" UA_INTRLCK_CTRL while export_count is %d\n",
-			da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device"
+			   " UA_INTRLCK_CTRL while export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 	da->emulate_ua_intlck_ctrl = val;
-	pr_debug("dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
-		da->da_dev, val);
+	target_debug("dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n", da->da_dev, val);
 	return count;
 }
 
@@ -747,14 +751,14 @@ static ssize_t emulate_tas_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device TAS while"
-			" export_count is %d\n",
-			da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device TAS while"
+			   " export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 	da->emulate_tas = flag;
-	pr_debug("dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
-		da->da_dev, flag ? "Enabled" : "Disabled");
+	target_debug("dev[%p]: SE Device TASK_ABORTED status bit: %s\n", da->da_dev,
+		     flag ? "Enabled" : "Disabled");
 
 	return count;
 }
@@ -763,19 +767,18 @@ static int target_try_configure_unmap(struct se_device *dev,
 				      const char *config_opt)
 {
 	if (!dev->transport->configure_unmap) {
-		pr_err("Generic Block Discard not supported\n");
+		target_err("Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
 
 	if (!target_dev_configured(dev)) {
-		pr_err("Generic Block Discard setup for %s requires device to be configured\n",
-		       config_opt);
+		target_err("Generic Block Discard setup for %s requires device to be configured\n",
+			   config_opt);
 		return -ENODEV;
 	}
 
 	if (!dev->transport->configure_unmap(dev)) {
-		pr_err("Generic Block Discard setup for %s failed\n",
-		       config_opt);
+		target_err("Generic Block Discard setup for %s failed\n", config_opt);
 		return -ENOSYS;
 	}
 
@@ -805,8 +808,7 @@ static ssize_t emulate_tpu_store(struct config_item *item,
 	}
 
 	da->emulate_tpu = flag;
-	pr_debug("dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
-		da->da_dev, flag);
+	target_debug("dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -833,8 +835,7 @@ static ssize_t emulate_tpws_store(struct config_item *item,
 	}
 
 	da->emulate_tpws = flag;
-	pr_debug("dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
-				da->da_dev, flag);
+	target_debug("dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -851,16 +852,16 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 		return ret;
 
 	if (flag != 0 && flag != 1 && flag != 2 && flag != 3) {
-		pr_err("Illegal value %d for pi_prot_type\n", flag);
+		target_err("Illegal value %d for pi_prot_type\n", flag);
 		return -EINVAL;
 	}
 	if (flag == 2) {
-		pr_err("DIF TYPE2 protection currently not supported\n");
+		target_err("DIF TYPE2 protection currently not supported\n");
 		return -ENOSYS;
 	}
 	if (da->hw_pi_prot_type) {
-		pr_warn("DIF protection enabled on underlying hardware,"
-			" ignoring\n");
+		target_warn("DIF protection enabled on underlying hardware,"
+			    " ignoring\n");
 		return count;
 	}
 	if (!dev->transport->init_prot || !dev->transport->free_prot) {
@@ -868,17 +869,17 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 		if (flag == 0)
 			return count;
 
-		pr_err("DIF protection not supported by backend: %s\n",
-		       dev->transport->name);
+		target_err("DIF protection not supported by backend: %s\n", dev->transport->name);
 		return -ENOSYS;
 	}
 	if (!target_dev_configured(dev)) {
-		pr_err("DIF protection requires device to be configured\n");
+		target_err("DIF protection requires device to be configured\n");
 		return -ENODEV;
 	}
 	if (dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device PROT type while"
-		       " export_count is %d\n", dev, dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device PROT type while"
+			   " export_count is %d\n",
+			   dev, dev->export_count);
 		return -EINVAL;
 	}
 
@@ -897,7 +898,7 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 	}
 
 	da->pi_prot_verify = (bool) da->pi_prot_type;
-	pr_debug("dev[%p]: SE Device Protection Type: %d\n", dev, flag);
+	target_debug("dev[%p]: SE Device Protection Type: %d\n", dev, flag);
 	return count;
 }
 
@@ -923,17 +924,18 @@ static ssize_t pi_prot_format_store(struct config_item *item,
 		return count;
 
 	if (!dev->transport->format_prot) {
-		pr_err("DIF protection format not supported by backend %s\n",
-		       dev->transport->name);
+		target_err("DIF protection format not supported by backend %s\n",
+			   dev->transport->name);
 		return -ENOSYS;
 	}
 	if (!target_dev_configured(dev)) {
-		pr_err("DIF protection format requires device to be configured\n");
+		target_err("DIF protection format requires device to be configured\n");
 		return -ENODEV;
 	}
 	if (dev->export_count) {
-		pr_err("dev[%p]: Unable to format SE Device PROT type while"
-		       " export_count is %d\n", dev, dev->export_count);
+		target_err("dev[%p]: Unable to format SE Device PROT type while"
+			   " export_count is %d\n",
+			   dev, dev->export_count);
 		return -EINVAL;
 	}
 
@@ -941,7 +943,7 @@ static ssize_t pi_prot_format_store(struct config_item *item,
 	if (ret)
 		return ret;
 
-	pr_debug("dev[%p]: SE Device Protection Format complete\n", dev);
+	target_debug("dev[%p]: SE Device Protection Format complete\n", dev);
 	return count;
 }
 
@@ -961,12 +963,12 @@ static ssize_t pi_prot_verify_store(struct config_item *item,
 		return count;
 	}
 	if (da->hw_pi_prot_type) {
-		pr_warn("DIF protection enabled on underlying hardware,"
-			" ignoring\n");
+		target_warn("DIF protection enabled on underlying hardware,"
+			    " ignoring\n");
 		return count;
 	}
 	if (!da->pi_prot_type) {
-		pr_warn("DIF protection not supported by backend, ignoring\n");
+		target_warn("DIF protection not supported by backend, ignoring\n");
 		return count;
 	}
 	da->pi_prot_verify = flag;
@@ -985,14 +987,14 @@ static ssize_t force_pr_aptpl_store(struct config_item *item,
 	if (ret < 0)
 		return ret;
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to set force_pr_aptpl while"
-		       " export_count is %d\n",
-		       da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to set force_pr_aptpl while"
+			   " export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 
 	da->force_pr_aptpl = flag;
-	pr_debug("dev[%p]: SE Device force_pr_aptpl: %d\n", da->da_dev, flag);
+	target_debug("dev[%p]: SE Device force_pr_aptpl: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -1008,13 +1010,13 @@ static ssize_t emulate_rest_reord_store(struct config_item *item,
 		return ret;
 
 	if (flag != 0) {
-		printk(KERN_ERR "dev[%p]: SE Device emulation of restricted"
-			" reordering not implemented\n", da->da_dev);
+		target_err("dev[%p]: SE Device emulation of restricted"
+			   " reordering not implemented\n",
+			   da->da_dev);
 		return -ENOSYS;
 	}
 	da->emulate_rest_reord = flag;
-	pr_debug("dev[%p]: SE Device emulate_rest_reord: %d\n",
-		da->da_dev, flag);
+	target_debug("dev[%p]: SE Device emulate_rest_reord: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -1031,9 +1033,9 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device"
-		       " unmap_zeroes_data while export_count is %d\n",
-		       da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device"
+			   " unmap_zeroes_data while export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 	/*
@@ -1046,8 +1048,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 			return ret;
 	}
 	da->unmap_zeroes_data = flag;
-	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
-		 da->da_dev, flag);
+	target_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n", da->da_dev, flag);
 	return count;
 }
 
@@ -1067,27 +1068,27 @@ static ssize_t queue_depth_store(struct config_item *item,
 		return ret;
 
 	if (dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device TCQ while"
-			" export_count is %d\n",
-			dev, dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device TCQ while"
+			   " export_count is %d\n",
+			   dev, dev->export_count);
 		return -EINVAL;
 	}
 	if (!val) {
-		pr_err("dev[%p]: Illegal ZERO value for queue_depth\n", dev);
+		target_err("dev[%p]: Illegal ZERO value for queue_depth\n", dev);
 		return -EINVAL;
 	}
 
 	if (val > dev->dev_attrib.queue_depth) {
 		if (val > dev->dev_attrib.hw_queue_depth) {
-			pr_err("dev[%p]: Passed queue_depth:"
-				" %u exceeds TCM/SE_Device MAX"
-				" TCQ: %u\n", dev, val,
-				dev->dev_attrib.hw_queue_depth);
+			target_err("dev[%p]: Passed queue_depth:"
+				   " %u exceeds TCM/SE_Device MAX"
+				   " TCQ: %u\n",
+				   dev, val, dev->dev_attrib.hw_queue_depth);
 			return -EINVAL;
 		}
 	}
 	da->queue_depth = dev->queue_depth = val;
-	pr_debug("dev[%p]: SE Device TCQ Depth changed to: %u\n", dev, val);
+	target_debug("dev[%p]: SE Device TCQ Depth changed to: %u\n", dev, val);
 	return count;
 }
 
@@ -1103,21 +1104,20 @@ static ssize_t optimal_sectors_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device"
-			" optimal_sectors while export_count is %d\n",
-			da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device"
+			   " optimal_sectors while export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 	if (val > da->hw_max_sectors) {
-		pr_err("dev[%p]: Passed optimal_sectors %u cannot be"
-			" greater than hw_max_sectors: %u\n",
-			da->da_dev, val, da->hw_max_sectors);
+		target_err("dev[%p]: Passed optimal_sectors %u cannot be"
+			   " greater than hw_max_sectors: %u\n",
+			   da->da_dev, val, da->hw_max_sectors);
 		return -EINVAL;
 	}
 
 	da->optimal_sectors = val;
-	pr_debug("dev[%p]: SE Device optimal_sectors changed to %u\n",
-			da->da_dev, val);
+	target_debug("dev[%p]: SE Device optimal_sectors changed to %u\n", da->da_dev, val);
 	return count;
 }
 
@@ -1133,23 +1133,22 @@ static ssize_t block_size_store(struct config_item *item,
 		return ret;
 
 	if (da->da_dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device block_size"
-			" while export_count is %d\n",
-			da->da_dev, da->da_dev->export_count);
+		target_err("dev[%p]: Unable to change SE Device block_size"
+			   " while export_count is %d\n",
+			   da->da_dev, da->da_dev->export_count);
 		return -EINVAL;
 	}
 
 	if (val != 512 && val != 1024 && val != 2048 && val != 4096) {
-		pr_err("dev[%p]: Illegal value for block_device: %u"
-			" for SE device, must be 512, 1024, 2048 or 4096\n",
-			da->da_dev, val);
+		target_err("dev[%p]: Illegal value for block_device: %u"
+			   " for SE device, must be 512, 1024, 2048 or 4096\n",
+			   da->da_dev, val);
 		return -EINVAL;
 	}
 
 	da->block_size = val;
 
-	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
-			da->da_dev, val);
+	target_debug("dev[%p]: SE Device block_size changed to %u\n", da->da_dev, val);
 	return count;
 }
 
@@ -1180,8 +1179,9 @@ static ssize_t alua_support_store(struct config_item *item,
 
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
-		pr_err("dev[%p]: Unable to change SE Device alua_support:"
-			" alua_support has fixed value\n", dev);
+		target_err("dev[%p]: Unable to change SE Device alua_support:"
+			   " alua_support has fixed value\n",
+			   dev);
 		return -ENOSYS;
 	}
 
@@ -1219,8 +1219,9 @@ static ssize_t pgr_support_store(struct config_item *item,
 
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
-		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
-			" pgr_support has fixed value\n", dev);
+		target_err("dev[%p]: Unable to change SE Device pgr_support:"
+			   " pgr_support has fixed value\n",
+			   dev);
 		return -ENOSYS;
 	}
 
@@ -1243,8 +1244,8 @@ static ssize_t emulate_rsoc_store(struct config_item *item,
 		return ret;
 
 	da->emulate_rsoc = flag;
-	pr_debug("dev[%p]: SE Device REPORT_SUPPORTED_OPERATION_CODES_EMULATION flag: %d\n",
-			da->da_dev, flag);
+	target_debug("dev[%p]: SE Device REPORT_SUPPORTED_OPERATION_CODES_EMULATION flag: %d\n",
+		     da->da_dev, flag);
 	return count;
 }
 
@@ -1405,7 +1406,7 @@ static ssize_t target_check_inquiry_data(char *buf)
 	 */
 	for (i = 0; i < len; i++) {
 		if (buf[i] < 0x20 || buf[i] > 0x7E) {
-			pr_err("Emulated T10 Inquiry Data contains non-ASCII-printable characters\n");
+			target_err("Emulated T10 Inquiry Data contains non-ASCII-printable characters\n");
 			return -EINVAL;
 		}
 	}
@@ -1440,9 +1441,8 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 		len = strlen(stripped);
 	}
 	if (len < 0 || len > INQUIRY_VENDOR_LEN) {
-		pr_err("Emulated T10 Vendor Identification exceeds"
-			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
-			"\n");
+		target_err("Emulated T10 Vendor Identification exceeds"
+			   " INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN) "\n");
 		return -EOVERFLOW;
 	}
 
@@ -1458,16 +1458,18 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	 * effects.
 	 */
 	if (dev->export_count) {
-		pr_err("Unable to set T10 Vendor Identification while"
-			" active %d exports exist\n", dev->export_count);
+		target_err("Unable to set T10 Vendor Identification while"
+			   " active %d exports exist\n",
+			   dev->export_count);
 		return -EINVAL;
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
 	strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
 
-	pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
-		 " %s\n", dev->t10_wwn.vendor);
+	target_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
+		     " %s\n",
+		     dev->t10_wwn.vendor);
 
 	return count;
 }
@@ -1496,9 +1498,8 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 		len = strlen(stripped);
 	}
 	if (len < 0 || len > INQUIRY_MODEL_LEN) {
-		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
-			 __stringify(INQUIRY_MODEL_LEN)
-			"\n");
+		target_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
+			   __stringify(INQUIRY_MODEL_LEN) "\n");
 		return -EOVERFLOW;
 	}
 
@@ -1514,16 +1515,16 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	 * effects.
 	 */
 	if (dev->export_count) {
-		pr_err("Unable to set T10 Model while active %d exports exist\n",
-			dev->export_count);
+		target_err("Unable to set T10 Model while active %d exports exist\n",
+			   dev->export_count);
 		return -EINVAL;
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
 	strscpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
 
-	pr_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
-		 dev->t10_wwn.model);
+	target_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
+		     dev->t10_wwn.model);
 
 	return count;
 }
@@ -1552,9 +1553,8 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 		len = strlen(stripped);
 	}
 	if (len < 0 || len > INQUIRY_REVISION_LEN) {
-		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
-			 __stringify(INQUIRY_REVISION_LEN)
-			"\n");
+		target_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
+			   __stringify(INQUIRY_REVISION_LEN) "\n");
 		return -EOVERFLOW;
 	}
 
@@ -1570,16 +1570,16 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	 * effects.
 	 */
 	if (dev->export_count) {
-		pr_err("Unable to set T10 Revision while active %d exports exist\n",
-			dev->export_count);
+		target_err("Unable to set T10 Revision while active %d exports exist\n",
+			   dev->export_count);
 		return -EINVAL;
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
 	strscpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revision));
 
-	pr_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
-		 dev->t10_wwn.revision);
+	target_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
+		     dev->t10_wwn.revision);
 
 	return count;
 }
@@ -1619,15 +1619,13 @@ target_wwn_company_id_store(struct config_item *item,
 	 * effects.
 	 */
 	if (dev->export_count) {
-		pr_err("Unable to set Company ID while %u exports exist\n",
-		       dev->export_count);
+		target_err("Unable to set Company ID while %u exports exist\n", dev->export_count);
 		return -EINVAL;
 	}
 
 	t10_wwn->company_id = val;
 
-	pr_debug("Target_Core_ConfigFS: Set IEEE Company ID: %#08x\n",
-		 t10_wwn->company_id);
+	target_debug("Target_Core_ConfigFS: Set IEEE Company ID: %#08x\n", t10_wwn->company_id);
 
 	return count;
 }
@@ -1660,14 +1658,15 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * VPD Unit Serial Number that OS dependent multipath can depend on.
 	 */
 	if (dev->dev_flags & DF_FIRMWARE_VPD_UNIT_SERIAL) {
-		pr_err("Underlying SCSI device firmware provided VPD"
-			" Unit Serial, ignoring request\n");
+		target_err("Underlying SCSI device firmware provided VPD"
+			   " Unit Serial, ignoring request\n");
 		return -EOPNOTSUPP;
 	}
 
 	if (strlen(page) >= INQUIRY_VPD_SERIAL_LEN) {
-		pr_err("Emulated VPD Unit Serial exceeds"
-		" INQUIRY_VPD_SERIAL_LEN: %d\n", INQUIRY_VPD_SERIAL_LEN);
+		target_err("Emulated VPD Unit Serial exceeds"
+			   " INQUIRY_VPD_SERIAL_LEN: %d\n",
+			   INQUIRY_VPD_SERIAL_LEN);
 		return -EOVERFLOW;
 	}
 	/*
@@ -1677,9 +1676,9 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * could cause negative effects.
 	 */
 	if (dev->export_count) {
-		pr_err("Unable to set VPD Unit Serial while"
-			" active %d $FABRIC_MOD exports exist\n",
-			dev->export_count);
+		target_err("Unable to set VPD Unit Serial while"
+			   " active %d $FABRIC_MOD exports exist\n",
+			   dev->export_count);
 		return -EINVAL;
 	}
 
@@ -1694,8 +1693,9 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 			"%s", strstrip(buf));
 	dev->dev_flags |= DF_EMULATED_VPD_UNIT_SERIAL;
 
-	pr_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
-			" %s\n", dev->t10_wwn.unit_serial);
+	target_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
+		     " %s\n",
+		     dev->t10_wwn.unit_serial);
 
 	return count;
 }
@@ -2078,8 +2078,8 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		return count;
 
 	if (dev->export_count) {
-		pr_debug("Unable to process APTPL metadata while"
-			" active fabric exports exist\n");
+		target_debug("Unable to process APTPL metadata while"
+			     " active fabric exports exist\n");
 		return -EINVAL;
 	}
 
@@ -2108,9 +2108,9 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(i_port) >= PR_APTPL_MAX_IPORT_LEN) {
-				pr_err("APTPL metadata initiator_node="
-					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
-					PR_APTPL_MAX_IPORT_LEN);
+				target_err("APTPL metadata initiator_node="
+					   " exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
+					   PR_APTPL_MAX_IPORT_LEN);
 				ret = -EINVAL;
 				break;
 			}
@@ -2122,9 +2122,9 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(isid) >= PR_REG_ISID_LEN) {
-				pr_err("APTPL metadata initiator_isid"
-					"= exceeds PR_REG_ISID_LEN: %d\n",
-					PR_REG_ISID_LEN);
+				target_err("APTPL metadata initiator_isid"
+					   "= exceeds PR_REG_ISID_LEN: %d\n",
+					   PR_REG_ISID_LEN);
 				ret = -EINVAL;
 				break;
 			}
@@ -2132,7 +2132,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		case Opt_sa_res_key:
 			ret = match_u64(args,  &tmp_ll);
 			if (ret < 0) {
-				pr_err("kstrtoull() failed for sa_res_key=\n");
+				target_err("kstrtoull() failed for sa_res_key=\n");
 				goto out;
 			}
 			sa_res_key = (u64)tmp_ll;
@@ -2186,9 +2186,9 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			}
 			if (strlen(t_port) >= PR_APTPL_MAX_TPORT_LEN) {
-				pr_err("APTPL metadata target_node="
-					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
-					PR_APTPL_MAX_TPORT_LEN);
+				target_err("APTPL metadata target_node="
+					   " exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
+					   PR_APTPL_MAX_TPORT_LEN);
 				ret = -EINVAL;
 				break;
 			}
@@ -2216,14 +2216,15 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	}
 
 	if (!i_port || !t_port || !sa_res_key) {
-		pr_err("Illegal parameters for APTPL registration\n");
+		target_err("Illegal parameters for APTPL registration\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (res_holder && !(type)) {
-		pr_err("Illegal PR type: 0x%02x for reservation"
-				" holder\n", type);
+		target_err("Illegal PR type: 0x%02x for reservation"
+			   " holder\n",
+			   type);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2315,9 +2316,9 @@ static ssize_t target_dev_alias_store(struct config_item *item,
 	ssize_t read_bytes;
 
 	if (count > (SE_DEV_ALIAS_LEN-1)) {
-		pr_err("alias count: %d exceeds"
-			" SE_DEV_ALIAS_LEN-1: %u\n", (int)count,
-			SE_DEV_ALIAS_LEN-1);
+		target_err("alias count: %d exceeds"
+			   " SE_DEV_ALIAS_LEN-1: %u\n",
+			   (int)count, SE_DEV_ALIAS_LEN - 1);
 		return -EINVAL;
 	}
 
@@ -2329,10 +2330,9 @@ static ssize_t target_dev_alias_store(struct config_item *item,
 
 	dev->dev_flags |= DF_USING_ALIAS;
 
-	pr_debug("Target_Core_ConfigFS: %s/%s set alias: %s\n",
-		config_item_name(&hba->hba_group.cg_item),
-		config_item_name(&dev->dev_group.cg_item),
-		dev->dev_alias);
+	target_debug("Target_Core_ConfigFS: %s/%s set alias: %s\n",
+		     config_item_name(&hba->hba_group.cg_item),
+		     config_item_name(&dev->dev_group.cg_item), dev->dev_alias);
 
 	return read_bytes;
 }
@@ -2355,9 +2355,9 @@ static ssize_t target_dev_udev_path_store(struct config_item *item,
 	ssize_t read_bytes;
 
 	if (count > (SE_UDEV_PATH_LEN-1)) {
-		pr_err("udev_path count: %d exceeds"
-			" SE_UDEV_PATH_LEN-1: %u\n", (int)count,
-			SE_UDEV_PATH_LEN-1);
+		target_err("udev_path count: %d exceeds"
+			   " SE_UDEV_PATH_LEN-1: %u\n",
+			   (int)count, SE_UDEV_PATH_LEN - 1);
 		return -EINVAL;
 	}
 
@@ -2370,10 +2370,9 @@ static ssize_t target_dev_udev_path_store(struct config_item *item,
 
 	dev->dev_flags |= DF_USING_UDEV_PATH;
 
-	pr_debug("Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
-		config_item_name(&hba->hba_group.cg_item),
-		config_item_name(&dev->dev_group.cg_item),
-		dev->udev_path);
+	target_debug("Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
+		     config_item_name(&hba->hba_group.cg_item),
+		     config_item_name(&dev->dev_group.cg_item), dev->udev_path);
 
 	return read_bytes;
 }
@@ -2394,8 +2393,8 @@ static ssize_t target_dev_enable_store(struct config_item *item,
 
 	ptr = strstr(page, "1");
 	if (!ptr) {
-		pr_err("For dev_enable ops, only valid value"
-				" is \"1\"\n");
+		target_err("For dev_enable ops, only valid value"
+			   " is \"1\"\n");
 		return -EINVAL;
 	}
 
@@ -2444,7 +2443,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		return count;
 
 	if (count > LU_GROUP_NAME_BUF) {
-		pr_err("ALUA LU Group Alias too large!\n");
+		target_err("ALUA LU Group Alias too large!\n");
 		return -EINVAL;
 	}
 	memcpy(buf, page, count);
@@ -2471,13 +2470,13 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		 * with NULL
 		 */
 		if (!lu_gp_new) {
-			pr_debug("Target_Core_ConfigFS: Releasing %s/%s"
-				" from ALUA LU Group: core/alua/lu_gps/%s, ID:"
-				" %hu\n",
-				config_item_name(&hba->hba_group.cg_item),
-				config_item_name(&dev->dev_group.cg_item),
-				config_item_name(&lu_gp->lu_gp_group.cg_item),
-				lu_gp->lu_gp_id);
+			target_debug("Target_Core_ConfigFS: Releasing %s/%s"
+				     " from ALUA LU Group: core/alua/lu_gps/%s, ID:"
+				     " %hu\n",
+				     config_item_name(&hba->hba_group.cg_item),
+				     config_item_name(&dev->dev_group.cg_item),
+				     config_item_name(&lu_gp->lu_gp_group.cg_item),
+				     lu_gp->lu_gp_id);
 
 			__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
 			spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
@@ -2496,13 +2495,11 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	pr_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
-		" core/alua/lu_gps/%s, ID: %hu\n",
-		(move) ? "Moving" : "Adding",
-		config_item_name(&hba->hba_group.cg_item),
-		config_item_name(&dev->dev_group.cg_item),
-		config_item_name(&lu_gp_new->lu_gp_group.cg_item),
-		lu_gp_new->lu_gp_id);
+	target_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
+		     " core/alua/lu_gps/%s, ID: %hu\n",
+		     (move) ? "Moving" : "Adding", config_item_name(&hba->hba_group.cg_item),
+		     config_item_name(&dev->dev_group.cg_item),
+		     config_item_name(&lu_gp_new->lu_gp_group.cg_item), lu_gp_new->lu_gp_id);
 
 	core_alua_put_lu_gp_from_name(lu_gp_new);
 	return count;
@@ -2578,7 +2575,7 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 		if (num == 0) {
 			if (sscanf(ptr, "%lu %lu\n",
 				   &segment_size, &segment_mult) != 2) {
-				pr_err("Invalid line %d\n", num);
+				target_err("Invalid line %d\n", num);
 				ret = -EINVAL;
 				break;
 			}
@@ -2586,21 +2583,20 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 			continue;
 		}
 		if (sscanf(ptr, "%lu %lu", &start_lba, &end_lba) != 2) {
-			pr_err("Invalid line %d\n", num);
+			target_err("Invalid line %d\n", num);
 			ret = -EINVAL;
 			break;
 		}
 		ptr = strchr(ptr, ' ');
 		if (!ptr) {
-			pr_err("Invalid line %d, missing end lba\n", num);
+			target_err("Invalid line %d, missing end lba\n", num);
 			ret = -EINVAL;
 			break;
 		}
 		ptr++;
 		ptr = strchr(ptr, ' ');
 		if (!ptr) {
-			pr_err("Invalid line %d, missing state definitions\n",
-			       num);
+			target_err("Invalid line %d, missing state definitions\n", num);
 			ret = -EINVAL;
 			break;
 		}
@@ -2627,7 +2623,7 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 				alua_state = ALUA_ACCESS_STATE_UNAVAILABLE;
 				break;
 			default:
-				pr_err("Invalid ALUA state '%c'\n", state);
+				target_err("Invalid ALUA state '%c'\n", state);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -2635,9 +2631,9 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 			ret = core_alua_allocate_lba_map_mem(lba_map,
 							     pg_id, alua_state);
 			if (ret) {
-				pr_err("Invalid target descriptor %d:%c "
-				       "at line %d\n",
-				       pg_id, state, num);
+				target_err("Invalid target descriptor %d:%c "
+					   "at line %d\n",
+					   pg_id, state, num);
 				break;
 			}
 			pg++;
@@ -2650,8 +2646,8 @@ static ssize_t target_dev_lba_map_store(struct config_item *item,
 		if (pg_num == -1)
 		    pg_num = pg;
 		else if (pg != pg_num) {
-			pr_err("Only %d from %d port groups definitions "
-			       "at line %d\n", pg, pg_num, num);
+			target_err("Only %d from %d port groups definitions "
+				   "at line %d\n", pg, pg_num, num);
 			ret = -EINVAL;
 			break;
 		}
@@ -2735,13 +2731,15 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &lu_gp_id);
 	if (ret < 0) {
-		pr_err("kstrtoul() returned %d for"
-			" lu_gp_id\n", ret);
+		target_err("kstrtoul() returned %d for"
+			   " lu_gp_id\n",
+			   ret);
 		return ret;
 	}
 	if (lu_gp_id > 0x0000ffff) {
-		pr_err("ALUA lu_gp_id: %lu exceeds maximum:"
-			" 0x0000ffff\n", lu_gp_id);
+		target_err("ALUA lu_gp_id: %lu exceeds maximum:"
+			   " 0x0000ffff\n",
+			   lu_gp_id);
 		return -EINVAL;
 	}
 
@@ -2749,10 +2747,9 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	pr_debug("Target_Core_ConfigFS: Set ALUA Logical Unit"
-		" Group: core/alua/lu_gps/%s to ID: %hu\n",
-		config_item_name(&alua_lu_gp_cg->cg_item),
-		lu_gp->lu_gp_id);
+	target_debug("Target_Core_ConfigFS: Set ALUA Logical Unit"
+		     " Group: core/alua/lu_gps/%s to ID: %hu\n",
+		     config_item_name(&alua_lu_gp_cg->cg_item), lu_gp->lu_gp_id);
 
 	return count;
 }
@@ -2777,8 +2774,8 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			pr_warn("Ran out of lu_gp_show_attr"
-				"_members buffer\n");
+			target_warn("Ran out of lu_gp_show_attr"
+				    "_members buffer\n");
 			break;
 		}
 		memcpy(page+len, buf, cur_len);
@@ -2838,9 +2835,9 @@ static struct config_group *target_core_alua_create_lu_gp(
 	config_group_init_type_name(alua_lu_gp_cg, name,
 			&target_core_alua_lu_gp_cit);
 
-	pr_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit"
-		" Group: core/alua/lu_gps/%s\n",
-		config_item_name(alua_lu_gp_ci));
+	target_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit"
+		     " Group: core/alua/lu_gps/%s\n",
+		     config_item_name(alua_lu_gp_ci));
 
 	return alua_lu_gp_cg;
 
@@ -2853,9 +2850,9 @@ static void target_core_alua_drop_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
 			struct t10_alua_lu_gp, lu_gp_group);
 
-	pr_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit"
-		" Group: core/alua/lu_gps/%s, ID: %hu\n",
-		config_item_name(item), lu_gp->lu_gp_id);
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit"
+		     " Group: core/alua/lu_gps/%s, ID: %hu\n",
+		     config_item_name(item), lu_gp->lu_gp_id);
 	/*
 	 * core_alua_free_lu_gp() is called from target_core_alua_lu_gp_ops->release()
 	 * -> target_core_alua_lu_gp_release()
@@ -2900,33 +2897,34 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
 	int new_state, ret;
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to do implicit ALUA on invalid tg_pt_gp ID\n");
+		target_err("Unable to do implicit ALUA on invalid tg_pt_gp ID\n");
 		return -EINVAL;
 	}
 	if (!target_dev_configured(dev)) {
-		pr_err("Unable to set alua_access_state while device is"
-		       " not configured\n");
+		target_err("Unable to set alua_access_state while device is"
+			   " not configured\n");
 		return -ENODEV;
 	}
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract new ALUA access state from"
-				" %s\n", page);
+		target_err("Unable to extract new ALUA access state from"
+			   " %s\n",
+			   page);
 		return ret;
 	}
 	new_state = (int)tmp;
 
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICIT_ALUA)) {
-		pr_err("Unable to process implicit configfs ALUA"
-			" transition while TPGS_IMPLICIT_ALUA is disabled\n");
+		target_err("Unable to process implicit configfs ALUA"
+			   " transition while TPGS_IMPLICIT_ALUA is disabled\n");
 		return -EINVAL;
 	}
 	if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA &&
 	    new_state == ALUA_ACCESS_STATE_LBA_DEPENDENT) {
 		/* LBA DEPENDENT is only allowed with implicit ALUA */
-		pr_err("Unable to process implicit configfs ALUA transition"
-		       " while explicit ALUA management is enabled\n");
+		target_err("Unable to process implicit configfs ALUA transition"
+			   " while explicit ALUA management is enabled\n");
 		return -EINVAL;
 	}
 
@@ -2951,14 +2949,15 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
 	int new_status, ret;
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to set ALUA access status on invalid tg_pt_gp ID\n");
+		target_err("Unable to set ALUA access status on invalid tg_pt_gp ID\n");
 		return -EINVAL;
 	}
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract new ALUA access status"
-				" from %s\n", page);
+		target_err("Unable to extract new ALUA access status"
+			   " from %s\n",
+			   page);
 		return ret;
 	}
 	new_status = (int)tmp;
@@ -2966,8 +2965,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
 	if ((new_status != ALUA_STATUS_NONE) &&
 	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
 	    (new_status != ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA)) {
-		pr_err("Illegal ALUA access status: 0x%02x\n",
-				new_status);
+		target_err("Illegal ALUA access status: 0x%02x\n", new_status);
 		return -EINVAL;
 	}
 
@@ -3004,17 +3002,17 @@ static ssize_t target_tg_pt_gp_alua_support_##_name##_store(		\
 	int ret;							\
 									\
 	if (!t->tg_pt_gp_valid_id) {					\
-		pr_err("Unable to set " #_name " ALUA state on invalid tg_pt_gp ID\n"); \
+		target_err("Unable to set " #_name " ALUA state on invalid tg_pt_gp ID\n");\
 		return -EINVAL;						\
 	}								\
 									\
 	ret = kstrtoul(p, 0, &tmp);					\
 	if (ret < 0) {							\
-		pr_err("Invalid value '%s', must be '0' or '1'\n", p);	\
+		target_err("Invalid value '%s', must be '0' or '1'\n", p);\
 		return -EINVAL;						\
 	}								\
 	if (tmp > 1) {							\
-		pr_err("Invalid value '%ld', must be '0' or '1'\n", tmp); \
+		target_err("Invalid value '%ld', must be '0' or '1'\n", tmp);\
 		return -EINVAL;						\
 	}								\
 	if (tmp)							\
@@ -3049,13 +3047,14 @@ static ssize_t target_tg_pt_gp_alua_write_metadata_store(
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-		pr_err("Unable to extract alua_write_metadata\n");
+		target_err("Unable to extract alua_write_metadata\n");
 		return ret;
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
-		pr_err("Illegal value for alua_write_metadata:"
-			" %lu\n", tmp);
+		target_err("Illegal value for alua_write_metadata:"
+			   " %lu\n",
+			   tmp);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_write_metadata = (int)tmp;
@@ -3134,13 +3133,11 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &tg_pt_gp_id);
 	if (ret < 0) {
-		pr_err("ALUA tg_pt_gp_id: invalid value '%s' for tg_pt_gp_id\n",
-		       page);
+		target_err("ALUA tg_pt_gp_id: invalid value '%s' for tg_pt_gp_id\n", page);
 		return ret;
 	}
 	if (tg_pt_gp_id > 0x0000ffff) {
-		pr_err("ALUA tg_pt_gp_id: %lu exceeds maximum: 0x0000ffff\n",
-		       tg_pt_gp_id);
+		target_err("ALUA tg_pt_gp_id: %lu exceeds maximum: 0x0000ffff\n", tg_pt_gp_id);
 		return -EINVAL;
 	}
 
@@ -3148,10 +3145,9 @@ static ssize_t target_tg_pt_gp_tg_pt_gp_id_store(struct config_item *item,
 	if (ret < 0)
 		return -EINVAL;
 
-	pr_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: "
-		"core/alua/tg_pt_gps/%s to ID: %hu\n",
-		config_item_name(&alua_tg_pt_gp_cg->cg_item),
-		tg_pt_gp->tg_pt_gp_id);
+	target_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: "
+		     "core/alua/tg_pt_gps/%s to ID: %hu\n",
+		     config_item_name(&alua_tg_pt_gp_cg->cg_item), tg_pt_gp->tg_pt_gp_id);
 
 	return count;
 }
@@ -3177,8 +3173,8 @@ static ssize_t target_tg_pt_gp_members_show(struct config_item *item,
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			pr_warn("Ran out of lu_gp_show_attr"
-				"_members buffer\n");
+			target_warn("Ran out of lu_gp_show_attr"
+				    "_members buffer\n");
 			break;
 		}
 		memcpy(page+len, buf, cur_len);
@@ -3270,9 +3266,9 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	config_group_init_type_name(alua_tg_pt_gp_cg, name,
 			&target_core_alua_tg_pt_gp_cit);
 
-	pr_debug("Target_Core_ConfigFS: Allocated ALUA Target Port"
-		" Group: alua/tg_pt_gps/%s\n",
-		config_item_name(alua_tg_pt_gp_ci));
+	target_debug("Target_Core_ConfigFS: Allocated ALUA Target Port"
+		     " Group: alua/tg_pt_gps/%s\n",
+		     config_item_name(alua_tg_pt_gp_ci));
 
 	return alua_tg_pt_gp_cg;
 }
@@ -3284,9 +3280,9 @@ static void target_core_alua_drop_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
 			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
 
-	pr_debug("Target_Core_ConfigFS: Releasing ALUA Target Port"
-		" Group: alua/tg_pt_gps/%s, ID: %hu\n",
-		config_item_name(item), tg_pt_gp->tg_pt_gp_id);
+	target_debug("Target_Core_ConfigFS: Releasing ALUA Target Port"
+		     " Group: alua/tg_pt_gps/%s, ID: %hu\n",
+		     config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 	/*
 	 * core_alua_free_tg_pt_gp() is called from target_core_alua_tg_pt_gp_ops->release()
 	 * -> target_core_alua_tg_pt_gp_release().
@@ -3505,12 +3501,12 @@ static ssize_t target_hba_mode_store(struct config_item *item,
 
 	ret = kstrtoul(page, 0, &mode_flag);
 	if (ret < 0) {
-		pr_err("Unable to extract hba mode flag: %d\n", ret);
+		target_err("Unable to extract hba mode flag: %d\n", ret);
 		return ret;
 	}
 
 	if (hba->dev_count) {
-		pr_err("Unable to set hba_mode with active devices\n");
+		target_err("Unable to set hba_mode with active devices\n");
 		return -EINVAL;
 	}
 
@@ -3563,16 +3559,16 @@ static struct config_group *target_core_call_addhbatotarget(
 	int ret;
 
 	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
-		pr_err("Passed *name strlen(): %d exceeds"
-			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
-			TARGET_CORE_NAME_MAX_LEN);
+		target_err("Passed *name strlen(): %d exceeds"
+			   " TARGET_CORE_NAME_MAX_LEN: %d\n",
+			   (int)strlen(name), TARGET_CORE_NAME_MAX_LEN);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
 
 	str = strstr(buf, "_");
 	if (!str) {
-		pr_err("Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
+		target_err("Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
 		return ERR_PTR(-EINVAL);
 	}
 	se_plugin_str = buf;
@@ -3592,8 +3588,9 @@ static struct config_group *target_core_call_addhbatotarget(
 
 	ret = kstrtoul(str, 0, &plugin_dep_id);
 	if (ret < 0) {
-		pr_err("kstrtoul() returned %d for"
-				" plugin_dep_id\n", ret);
+		target_err("kstrtoul() returned %d for"
+			   " plugin_dep_id\n",
+			   ret);
 		return ERR_PTR(ret);
 	}
 	/*
@@ -3654,18 +3651,18 @@ static void target_init_dbroot(void)
 	snprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
 	fp = filp_open(db_root_stage, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
-		pr_err("db_root: cannot open: %s\n", db_root_stage);
+		target_err("db_root: cannot open: %s\n", db_root_stage);
 		return;
 	}
 	if (!S_ISDIR(file_inode(fp)->i_mode)) {
 		filp_close(fp, NULL);
-		pr_err("db_root: not a valid directory: %s\n", db_root_stage);
+		target_err("db_root: not a valid directory: %s\n", db_root_stage);
 		return;
 	}
 	filp_close(fp, NULL);
 
 	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
-	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+	target_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
 
 static int __init target_core_init_configfs(void)
@@ -3676,9 +3673,9 @@ static int __init target_core_init_configfs(void)
 	const struct cred *old_cred;
 	int ret;
 
-	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
-		" Engine: %s on %s/%s on "UTS_RELEASE"\n",
-		TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
+	target_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
+		     " Engine: %s on %s/%s on " UTS_RELEASE "\n",
+		     TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
 
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
@@ -3728,13 +3725,14 @@ static int __init target_core_init_configfs(void)
 	 */
 	ret = configfs_register_subsystem(subsys);
 	if (ret < 0) {
-		pr_err("Error %d while registering subsystem %s\n",
-			ret, subsys->su_group.cg_item.ci_namebuf);
+		target_err("Error %d while registering subsystem %s\n", ret,
+			   subsys->su_group.cg_item.ci_namebuf);
 		goto out_global;
 	}
-	pr_debug("TARGET_CORE[0]: Initialized ConfigFS Fabric"
-		" Infrastructure: "TARGET_CORE_VERSION" on %s/%s"
-		" on "UTS_RELEASE"\n", utsname()->sysname, utsname()->machine);
+	target_debug("TARGET_CORE[0]: Initialized ConfigFS Fabric"
+		     " Infrastructure: " TARGET_CORE_VERSION " on %s/%s"
+		     " on " UTS_RELEASE "\n",
+		     utsname()->sysname, utsname()->machine);
 	/*
 	 * Register built-in RAMDISK subsystem logic for virtual LUN 0
 	 */
@@ -3792,8 +3790,8 @@ static void __exit target_core_exit_configfs(void)
 	core_alua_free_lu_gp(default_lu_gp);
 	default_lu_gp = NULL;
 
-	pr_debug("TARGET_CORE[0]: Released ConfigFS Fabric"
-			" Infrastructure\n");
+	target_debug("TARGET_CORE[0]: Released ConfigFS Fabric"
+		     " Infrastructure\n");
 
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index bb84d304b07e..7e530bdab04e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -66,10 +66,9 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
-			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				" Access for 0x%08llx\n",
-				se_cmd->se_tfo->fabric_name,
-				se_cmd->orig_fe_lun);
+			target_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				   " Access for 0x%08llx\n",
+				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun);
 			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
 		}
@@ -96,11 +95,10 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 		 * MappedLUN=0 exists for this Initiator Port.
 		 */
 		if (se_cmd->orig_fe_lun != 0) {
-			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-				" Access for 0x%08llx from %s\n",
-				se_cmd->se_tfo->fabric_name,
-				se_cmd->orig_fe_lun,
-				nacl->initiatorname);
+			target_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
+				   " Access for 0x%08llx from %s\n",
+				   se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun,
+				   nacl->initiatorname);
 			return TCM_NON_EXISTENT_LUN;
 		}
 
@@ -166,11 +164,9 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	rcu_read_unlock();
 
 	if (!se_lun) {
-		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-			" Access for 0x%08llx for %s\n",
-			se_cmd->se_tfo->fabric_name,
-			se_cmd->orig_fe_lun,
-			nacl->initiatorname);
+		target_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
+			     " Access for 0x%08llx for %s\n",
+			     se_cmd->se_tfo->fabric_name, se_cmd->orig_fe_lun, nacl->initiatorname);
 		return -ENODEV;
 	}
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
@@ -212,9 +208,9 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		lun = deve->se_lun;
 		if (!lun) {
-			pr_err("%s device entries device pointer is"
-				" NULL, but Initiator has access.\n",
-				tpg->se_tpg_tfo->fabric_name);
+			target_err("%s device entries device pointer is"
+				   " NULL, but Initiator has access.\n",
+				   tpg->se_tpg_tfo->fabric_name);
 			continue;
 		}
 		if (lun->lun_tpg->tpg_rtpi != rtpi)
@@ -325,7 +321,7 @@ int core_enable_device_list_for_node(
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
-		pr_err("Unable to allocate se_dev_entry memory\n");
+		target_err("Unable to allocate se_dev_entry memory\n");
 		return -ENOMEM;
 	}
 
@@ -347,18 +343,19 @@ int core_enable_device_list_for_node(
 		struct se_lun *orig_lun = orig->se_lun;
 
 		if (orig_lun != lun) {
-			pr_err("Existing orig->se_lun doesn't match new lun"
-			       " for dynamic -> explicit NodeACL conversion:"
-				" %s\n", nacl->initiatorname);
+			target_err("Existing orig->se_lun doesn't match new lun"
+				   " for dynamic -> explicit NodeACL conversion:"
+				   " %s\n",
+				   nacl->initiatorname);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
 		}
 		if (orig->se_lun_acl != NULL) {
-			pr_warn_ratelimited("Detected existing explicit"
-				" se_lun_acl->se_lun_group reference for %s"
-				" mapped_lun: %llu, failing\n",
-				 nacl->initiatorname, mapped_lun);
+			target_warn_ratelimited("Detected existing explicit"
+						" se_lun_acl->se_lun_group reference for %s"
+						" mapped_lun: %llu, failing\n",
+						nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
 			kfree(new);
 			return -EINVAL;
@@ -498,8 +495,8 @@ static u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
 	aligned_max_sectors = rounddown(max_sectors, alignment);
 
 	if (max_sectors != aligned_max_sectors)
-		pr_info("Rounding down aligned max_sectors from %u to %u\n",
-			max_sectors, aligned_max_sectors);
+		target_info("Rounding down aligned max_sectors from %u to %u\n", max_sectors,
+			    aligned_max_sectors);
 
 	return aligned_max_sectors;
 }
@@ -515,10 +512,10 @@ int core_dev_add_lun(
 	if (rc < 0)
 		return rc;
 
-	pr_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from"
-		" CORE HBA: %u\n", tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-		tpg->se_tpg_tfo->fabric_name, dev->se_hba->hba_id);
+	target_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from"
+		     " CORE HBA: %u\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name, dev->se_hba->hba_id);
 	/*
 	 * Update LUN maps for dynamically added initiators when
 	 * generate_node_acl is enabled.
@@ -548,10 +545,10 @@ void core_dev_del_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	pr_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from"
-		" device object\n", tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-		tpg->se_tpg_tfo->fabric_name);
+	target_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from"
+		     " device object\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     lun->unpacked_lun, tpg->se_tpg_tfo->fabric_name);
 
 	core_tpg_remove_lun(tpg, lun);
 }
@@ -565,14 +562,14 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_lun_acl *lacl;
 
 	if (strlen(nacl->initiatorname) >= TRANSPORT_IQN_LEN) {
-		pr_err("%s InitiatorName exceeds maximum size.\n",
-			tpg->se_tpg_tfo->fabric_name);
+		target_err("%s InitiatorName exceeds maximum size.\n",
+			   tpg->se_tpg_tfo->fabric_name);
 		*ret = -EOVERFLOW;
 		return NULL;
 	}
 	lacl = kzalloc(sizeof(struct se_lun_acl), GFP_KERNEL);
 	if (!lacl) {
-		pr_err("Unable to allocate memory for struct se_lun_acl.\n");
+		target_err("Unable to allocate memory for struct se_lun_acl.\n");
 		*ret = -ENOMEM;
 		return NULL;
 	}
@@ -608,11 +605,11 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access_ro, nacl, tpg) < 0)
 		return -EINVAL;
 
-	pr_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for "
-		" InitiatorNode: %s\n", tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
-		lun_access_ro ? "RO" : "RW",
-		nacl->initiatorname);
+	target_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for "
+		     " InitiatorNode: %s\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     lun->unpacked_lun, lacl->mapped_lun, lun_access_ro ? "RO" : "RW",
+		     nacl->initiatorname);
 	/*
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
@@ -640,11 +637,10 @@ int core_dev_del_initiator_node_lun_acl(
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	pr_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for"
-		" InitiatorNode: %s Mapped LUN: %llu\n",
-		tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-		nacl->initiatorname, lacl->mapped_lun);
+	target_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for"
+		     " InitiatorNode: %s Mapped LUN: %llu\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     lun->unpacked_lun, nacl->initiatorname, lacl->mapped_lun);
 
 	return 0;
 }
@@ -653,11 +649,11 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl)
 {
-	pr_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
-		" Mapped LUN: %llu\n", tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		tpg->se_tpg_tfo->fabric_name,
-		lacl->se_lun_nacl->initiatorname, lacl->mapped_lun);
+	target_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
+		     " Mapped LUN: %llu\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     tpg->se_tpg_tfo->fabric_name, lacl->se_lun_nacl->initiatorname,
+		     lacl->mapped_lun);
 
 	kfree(lacl);
 }
@@ -670,13 +666,10 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	/*
 	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
 	 */
-	pr_debug("  Vendor: %-" __stringify(INQUIRY_VENDOR_LEN) "s\n",
-		wwn->vendor);
-	pr_debug("  Model: %-" __stringify(INQUIRY_MODEL_LEN) "s\n",
-		wwn->model);
-	pr_debug("  Revision: %-" __stringify(INQUIRY_REVISION_LEN) "s\n",
-		wwn->revision);
-	pr_debug("  Type:   %s ", scsi_device_type(device_type));
+	target_debug("  Vendor: %-" __stringify(INQUIRY_VENDOR_LEN) "s\n", wwn->vendor);
+	target_debug("  Model: %-" __stringify(INQUIRY_MODEL_LEN) "s\n", wwn->model);
+	target_debug("  Revision: %-" __stringify(INQUIRY_REVISION_LEN) "s\n", wwn->revision);
+	target_debug("  Type:   %s ", scsi_device_type(device_type));
 }
 
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
@@ -897,8 +890,8 @@ int target_configure_device(struct se_device *dev)
 	int ret, id;
 
 	if (target_dev_configured(dev)) {
-		pr_err("se_dev->se_dev_ptr already set for storage"
-				" object\n");
+		target_err("se_dev->se_dev_ptr already set for storage"
+			   " object\n");
 		return -EEXIST;
 	}
 
@@ -925,7 +918,7 @@ int target_configure_device(struct se_device *dev)
 
 	if (dev->transport->configure_unmap &&
 	    dev->transport->configure_unmap(dev)) {
-		pr_debug("Discard support available, but disabled by default.\n");
+		target_debug("Discard support available, but disabled by default.\n");
 	}
 
 	/*
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..c2a4287361bd 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -43,7 +43,7 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 	cit->ct_group_ops = _group_ops;					\
 	cit->ct_attrs = _attrs;						\
 	cit->ct_owner = tf->tf_ops->module;				\
-	pr_debug("Setup generic %s\n", __stringify(_name));		\
+	target_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
 #define TF_CIT_SETUP_DRV(_name, _item_ops, _group_ops)		\
@@ -56,7 +56,7 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 	cit->ct_group_ops = _group_ops;					\
 	cit->ct_attrs = attrs;						\
 	cit->ct_owner = tf->tf_ops->module;				\
-	pr_debug("Setup generic %s\n", __stringify(_name));		\
+	target_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
 static struct configfs_item_operations target_fabric_port_item_ops;
@@ -77,7 +77,7 @@ static int target_fabric_mappedlun_link(
 
 	if (!lun_ci->ci_type ||
 	    lun_ci->ci_type->ct_item_ops != &target_fabric_port_item_ops) {
-		pr_err("Bad lun_ci, not a valid lun_ci pointer: %p\n", lun_ci);
+		target_err("Bad lun_ci, not a valid lun_ci pointer: %p\n", lun_ci);
 		return -EFAULT;
 	}
 	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
@@ -86,12 +86,12 @@ static int target_fabric_mappedlun_link(
 	 * Ensure that the source port exists
 	 */
 	if (!lun->lun_se_dev) {
-		pr_err("Source se_lun->lun_se_dev does not exist\n");
+		target_err("Source se_lun->lun_se_dev does not exist\n");
 		return -EINVAL;
 	}
 	if (lun->lun_shutdown) {
-		pr_err("Unable to create mappedlun symlink because"
-			" lun->lun_shutdown=true\n");
+		target_err("Unable to create mappedlun symlink because"
+			   " lun->lun_shutdown=true\n");
 		return -EINVAL;
 	}
 	se_tpg = lun->lun_tpg;
@@ -105,14 +105,14 @@ static int target_fabric_mappedlun_link(
 	 * Make sure the SymLink is going to the same $FABRIC/$WWN/tpgt_$TPGT
 	 */
 	if (strcmp(config_item_name(wwn_ci), config_item_name(wwn_ci_s))) {
-		pr_err("Illegal Initiator ACL SymLink outside of %s\n",
-			config_item_name(wwn_ci));
+		target_err("Illegal Initiator ACL SymLink outside of %s\n",
+			   config_item_name(wwn_ci));
 		return -EINVAL;
 	}
 	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
-		pr_err("Illegal Initiator ACL Symlink outside of %s"
-			" TPGT: %s\n", config_item_name(wwn_ci),
-			config_item_name(tpg_ci));
+		target_err("Illegal Initiator ACL Symlink outside of %s"
+			   " TPGT: %s\n",
+			   config_item_name(wwn_ci), config_item_name(tpg_ci));
 		return -EINVAL;
 	}
 	/*
@@ -194,10 +194,10 @@ static ssize_t target_fabric_mappedlun_write_protect_store(
 	/* wp=1 means lun_access_ro=true */
 	core_update_device_list_access(lacl->mapped_lun, wp, lacl->se_lun_nacl);
 
-	pr_debug("%s_ConfigFS: Changed Initiator ACL: %s"
-		" Mapped LUN: %llu Write Protect bit to %s\n",
-		se_tpg->se_tpg_tfo->fabric_name,
-		se_nacl->initiatorname, lacl->mapped_lun, (wp) ? "ON" : "OFF");
+	target_debug("%s_ConfigFS: Changed Initiator ACL: %s"
+		     " Mapped LUN: %llu Write Protect bit to %s\n",
+		     se_tpg->se_tpg_tfo->fabric_name, se_nacl->initiatorname, lacl->mapped_lun,
+		     (wp) ? "ON" : "OFF");
 
 	return count;
 
@@ -277,7 +277,7 @@ static struct config_group *target_fabric_make_mappedlun(
 
 	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
 	if (!buf) {
-		pr_err("Unable to allocate memory for name buf\n");
+		target_err("Unable to allocate memory for name buf\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	snprintf(buf, strlen(name) + 1, "%s", name);
@@ -285,8 +285,9 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
 	 */
 	if (strstr(buf, "lun_") != buf) {
-		pr_err("Unable to locate \"lun_\" from buf: %s"
-			" name: %s\n", buf, name);
+		target_err("Unable to locate \"lun_\" from buf: %s"
+			   " name: %s\n",
+			   buf, name);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -474,7 +475,7 @@ static struct config_group *target_fabric_make_np(
 	struct se_tpg_np *se_tpg_np;
 
 	if (!tf->tf_ops->fabric_make_np) {
-		pr_err("tf->tf_ops.fabric_make_np is NULL\n");
+		target_err("tf->tf_ops.fabric_make_np is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -631,13 +632,13 @@ static int target_fabric_port_link(
 
 	if (!se_dev_ci->ci_type ||
 	    se_dev_ci->ci_type->ct_item_ops != &target_core_dev_item_ops) {
-		pr_err("Bad se_dev_ci, not a valid se_dev_ci pointer: %p\n", se_dev_ci);
+		target_err("Bad se_dev_ci, not a valid se_dev_ci pointer: %p\n", se_dev_ci);
 		return -EFAULT;
 	}
 	dev = container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
 
 	if (!target_dev_configured(dev)) {
-		pr_err("se_device not configured yet, cannot port link\n");
+		target_err("se_device not configured yet, cannot port link\n");
 		return -ENODEV;
 	}
 
@@ -647,13 +648,13 @@ static int target_fabric_port_link(
 	tf = se_tpg->se_tpg_wwn->wwn_tf;
 
 	if (lun->lun_se_dev !=  NULL) {
-		pr_err("Port Symlink already exists\n");
+		target_err("Port Symlink already exists\n");
 		return -EEXIST;
 	}
 
 	ret = core_dev_add_lun(se_tpg, dev, lun);
 	if (ret) {
-		pr_err("core_dev_add_lun() failed: %d\n", ret);
+		target_err("core_dev_add_lun() failed: %d\n", ret);
 		goto out;
 	}
 
@@ -749,8 +750,8 @@ static struct config_group *target_fabric_make_lun(
 	int errno;
 
 	if (strstr(name, "lun_") != name) {
-		pr_err("Unable to locate \'_\" in"
-				" \"lun_$LUN_NUMBER\"\n");
+		target_err("Unable to locate \'_\" in"
+			   " \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
 	errno = kstrtoull(name + 4, 0, &unpacked_lun);
@@ -865,9 +866,9 @@ static ssize_t target_fabric_tpg_base_rtpi_store(struct config_item *item,
 		return -EINVAL;
 
 	if (se_tpg->enabled) {
-		pr_info("%s_TPG[%hu] - Can not change RTPI on enabled TPG",
-			se_tpg->se_tpg_tfo->fabric_name,
-			se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+		target_info("%s_TPG[%hu] - Can not change RTPI on enabled TPG",
+			    se_tpg->se_tpg_tfo->fabric_name,
+			    se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 		return -EINVAL;
 	}
 
@@ -915,7 +916,7 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
 	cit->ct_attrs = attrs;
 	cit->ct_owner = tf->tf_ops->module;
-	pr_debug("Setup generic tpg_base\n");
+	target_debug("Setup generic tpg_base\n");
 
 	return 0;
 }
@@ -932,7 +933,7 @@ static struct config_group *target_fabric_make_tpg(
 	struct se_portal_group *se_tpg;
 
 	if (!tf->tf_ops->fabric_make_tpg) {
-		pr_err("tf->tf_ops->fabric_make_tpg is NULL\n");
+		target_err("tf->tf_ops->fabric_make_tpg is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -1053,9 +1054,8 @@ target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
 	default:
 		if (compl_val < 0 || compl_val >= nr_cpu_ids ||
 		    !cpu_online(compl_val)) {
-			pr_err("Command completion value must be between %d and %d or an online CPU.\n",
-			       SE_COMPL_AFFINITY_CPUID,
-			       SE_COMPL_AFFINITY_CURR_CPU);
+			target_err("Command completion value must be between %d and %d or an online CPU.\n",
+				   SE_COMPL_AFFINITY_CPUID, SE_COMPL_AFFINITY_CURR_CPU);
 			return -EINVAL;
 		}
 		wwn->cmd_compl_affinity = compl_val;
@@ -1107,7 +1107,7 @@ static struct config_group *target_fabric_make_wwn(
 	struct se_wwn *wwn;
 
 	if (!tf->tf_ops->fabric_make_wwn) {
-		pr_err("tf->tf_ops.fabric_make_wwn is NULL\n");
+		target_err("tf->tf_ops.fabric_make_wwn is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6600ae44f29d..9e619e0028ce 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -42,7 +42,7 @@ static int sas_get_pr_transport_id(
 	/* Skip over 'naa. prefix */
 	ret = hex2bin(&buf[4], &nacl->initiatorname[4], 8);
 	if (ret) {
-		pr_debug("%s: invalid hex string\n", __func__);
+		target_debug("%s: invalid hex string\n", __func__);
 		return ret;
 	}
 
@@ -70,7 +70,7 @@ static int fc_get_pr_transport_id(
 		}
 		ret = hex2bin(&buf[off++], &ptr[i], 1);
 		if (ret < 0) {
-			pr_debug("%s: invalid hex string\n", __func__);
+			target_debug("%s: invalid hex string\n", __func__);
 			return ret;
 		}
 		i += 2;
@@ -90,7 +90,7 @@ static int sbp_get_pr_transport_id(
 
 	ret = hex2bin(&buf[8], nacl->initiatorname, 8);
 	if (ret) {
-		pr_debug("%s: invalid hex string\n", __func__);
+		target_debug("%s: invalid hex string\n", __func__);
 		return ret;
 	}
 
@@ -118,7 +118,7 @@ static int srp_get_pr_transport_id(
 	memset(buf + 8, 0, leading_zero_bytes);
 	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
 	if (rc < 0) {
-		pr_debug("hex2bin failed for %s: %d\n", p, rc);
+		target_debug("hex2bin failed for %s: %d\n", p, rc);
 		return rc;
 	}
 
@@ -280,8 +280,9 @@ static char *iscsi_parse_pr_out_transport_id(
 	 *            Reserved
 	 */
 	if ((format_code != 0x00) && (format_code != 0x40)) {
-		pr_err("Illegal format code: 0x%02x for iSCSI"
-			" Initiator Transport ID\n", format_code);
+		target_err("Illegal format code: 0x%02x for iSCSI"
+			   " Initiator Transport ID\n",
+			   format_code);
 		return NULL;
 	}
 	/*
@@ -303,9 +304,9 @@ static char *iscsi_parse_pr_out_transport_id(
 	if (format_code == 0x40) {
 		p = strstr(&buf[4], ",i,0x");
 		if (!p) {
-			pr_err("Unable to locate \",i,0x\" separator"
-				" for Initiator port identifier: %s\n",
-				&buf[4]);
+			target_err("Unable to locate \",i,0x\" separator"
+				   " for Initiator port identifier: %s\n",
+				   &buf[4]);
 			return NULL;
 		}
 		*p = '\0'; /* Terminate iSCSI Name */
@@ -354,7 +355,7 @@ int target_get_pr_transport_id_len(struct se_node_acl *nacl,
 	case SCSI_PROTOCOL_ISCSI:
 		return iscsi_get_pr_transport_id_len(nacl, pr_reg, format_code);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
+		target_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
 		return -EINVAL;
 	}
 
@@ -382,7 +383,7 @@ int target_get_pr_transport_id(struct se_node_acl *nacl,
 		return iscsi_get_pr_transport_id(nacl, pr_reg, format_code,
 				buf);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
+		target_err("Unknown proto_id: 0x%02x\n", nacl->se_tpg->proto_id);
 		return -EINVAL;
 	}
 }
@@ -409,7 +410,7 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 		return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
 					port_nexus_ptr);
 	default:
-		pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
+		target_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
 		return NULL;
 	}
 
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 94e6cd4e7e43..e1ac26e2f35a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -40,7 +40,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	fd_host = kzalloc(sizeof(struct fd_host), GFP_KERNEL);
 	if (!fd_host) {
-		pr_err("Unable to allocate memory for struct fd_host\n");
+		target_err("Unable to allocate memory for struct fd_host\n");
 		return -ENOMEM;
 	}
 
@@ -48,11 +48,11 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = fd_host;
 
-	pr_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
-		" Target Core Stack %s\n", hba->hba_id, FD_VERSION,
-		TARGET_CORE_VERSION);
-	pr_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic\n",
-		hba->hba_id, fd_host->fd_host_id);
+	target_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
+		     " Target Core Stack %s\n",
+		     hba->hba_id, FD_VERSION, TARGET_CORE_VERSION);
+	target_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic\n", hba->hba_id,
+		     fd_host->fd_host_id);
 
 	return 0;
 }
@@ -61,8 +61,9 @@ static void fd_detach_hba(struct se_hba *hba)
 {
 	struct fd_host *fd_host = hba->hba_ptr;
 
-	pr_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
-		" Target Core\n", hba->hba_id, fd_host->fd_host_id);
+	target_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
+		     " Target Core\n",
+		     hba->hba_id, fd_host->fd_host_id);
 
 	kfree(fd_host);
 	hba->hba_ptr = NULL;
@@ -75,13 +76,13 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 
 	fd_dev = kzalloc(sizeof(struct fd_dev), GFP_KERNEL);
 	if (!fd_dev) {
-		pr_err("Unable to allocate memory for struct fd_dev\n");
+		target_err("Unable to allocate memory for struct fd_dev\n");
 		return NULL;
 	}
 
 	fd_dev->fd_host = fd_host;
 
-	pr_debug("FILEIO: Allocated fd_dev for %p\n", name);
+	target_debug("FILEIO: Allocated fd_dev for %p\n", name);
 
 	return &fd_dev->dev;
 }
@@ -113,7 +114,7 @@ static int fd_configure_device(struct se_device *dev)
 	int flags, ret = -EINVAL;
 
 	if (!(fd_dev->fbd_flags & FBDF_HAS_PATH)) {
-		pr_err("Missing fd_dev_name=\n");
+		target_err("Missing fd_dev_name=\n");
 		return -EINVAL;
 	}
 
@@ -133,13 +134,13 @@ static int fd_configure_device(struct se_device *dev)
 	 * to write-out the entire device cache.
 	 */
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
-		pr_debug("FILEIO: Disabling O_DSYNC, using buffered FILEIO\n");
+		target_debug("FILEIO: Disabling O_DSYNC, using buffered FILEIO\n");
 		flags &= ~O_DSYNC;
 	}
 
 	file = filp_open(fd_dev->fd_dev_name, flags, 0600);
 	if (IS_ERR(file)) {
-		pr_err("filp_open(%s) failed\n", fd_dev->fd_dev_name);
+		target_err("filp_open(%s) failed\n", fd_dev->fd_dev_name);
 		ret = PTR_ERR(file);
 		goto fail;
 	}
@@ -163,10 +164,10 @@ static int fd_configure_device(struct se_device *dev)
 		dev_size = (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
 
-		pr_debug("FILEIO: Using size: %llu bytes from struct"
-			" block_device blocks: %llu logical_block_size: %d\n",
-			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
-			fd_dev->fd_block_size);
+		target_debug("FILEIO: Using size: %llu bytes from struct"
+			     " block_device blocks: %llu logical_block_size: %d\n",
+			     dev_size, div_u64(dev_size, fd_dev->fd_block_size),
+			     fd_dev->fd_block_size);
 		/*
 		 * Enable write same emulation for IBLOCK and use 0xFFFF as
 		 * the smaller WRITE_SAME(10) only has a two-byte block count.
@@ -177,9 +178,9 @@ static int fd_configure_device(struct se_device *dev)
 			dev->dev_attrib.is_nonrot = 1;
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
-			pr_err("FILEIO: Missing fd_dev_size="
-				" parameter, and no backing struct"
-				" block_device\n");
+			target_err("FILEIO: Missing fd_dev_size="
+				   " parameter, and no backing struct"
+				   " block_device\n");
 			goto fail;
 		}
 
@@ -197,17 +198,18 @@ static int fd_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
-		pr_debug("FILEIO: Forcing setting of emulate_write_cache=1"
-			" with FDBD_HAS_BUFFERED_IO_WCE\n");
+		target_debug("FILEIO: Forcing setting of emulate_write_cache=1"
+			     " with FDBD_HAS_BUFFERED_IO_WCE\n");
 		dev->dev_attrib.emulate_write_cache = 1;
 	}
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
-	pr_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
-		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
-			fd_dev->fd_dev_name, fd_dev->fd_dev_size);
+	target_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
+		     " %llu total bytes\n",
+		     fd_host->fd_host_id, fd_dev->fd_dev_id, fd_dev->fd_dev_name,
+		     fd_dev->fd_dev_size);
 
 	return 0;
 fail:
@@ -322,7 +324,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 
 	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
 	if (!bvec) {
-		pr_err("Unable to allocate fd_do_readv iov[]\n");
+		target_err("Unable to allocate fd_do_readv iov[]\n");
 		return -ENOMEM;
 	}
 
@@ -339,7 +341,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 
 	if (is_write) {
 		if (ret < 0 || ret != data_length) {
-			pr_err("%s() write returned %d\n", __func__, ret);
+			target_err("%s() write returned %d\n", __func__, ret);
 			if (ret >= 0)
 				ret = -EINVAL;
 		}
@@ -351,16 +353,15 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		 */
 		if (S_ISBLK(file_inode(fd)->i_mode)) {
 			if (ret < 0 || ret != data_length) {
-				pr_err("%s() returned %d, expecting %u for "
-						"S_ISBLK\n", __func__, ret,
-						data_length);
+				target_err("%s() returned %d, expecting %u for "
+					   "S_ISBLK\n",
+					   __func__, ret, data_length);
 				if (ret >= 0)
 					ret = -EINVAL;
 			}
 		} else {
 			if (ret < 0) {
-				pr_err("%s() returned %d for non S_ISBLK\n",
-						__func__, ret);
+				target_err("%s() returned %d for non S_ISBLK\n", __func__, ret);
 			} else if (ret != data_length) {
 				/*
 				 * Short read case:
@@ -411,7 +412,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 
 	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	if (ret != 0)
-		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
+		target_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
 
 	if (immed)
 		return 0;
@@ -437,8 +438,8 @@ fd_execute_write_same(struct se_cmd *cmd)
 	ssize_t ret;
 
 	if (cmd->prot_op) {
-		pr_err("WRITE_SAME: Protection information with FILEIO"
-		       " backends not supported\n");
+		target_err("WRITE_SAME: Protection information with FILEIO"
+			   " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -447,11 +448,10 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
-		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			" block_size: %u\n",
-			cmd->t_data_nents,
-			cmd->t_data_sg[0].length,
-			cmd->se_dev->dev_attrib.block_size);
+		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
+			   " block_size: %u\n",
+			   cmd->t_data_nents, cmd->t_data_sg[0].length,
+			   cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -471,7 +471,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	kfree(bvec);
 	if (ret < 0 || ret != len) {
-		pr_err("vfs_iter_write() returned %zd for write same\n", ret);
+		target_err("vfs_iter_write() returned %zd for write same\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -489,7 +489,7 @@ fd_do_prot_fill(struct se_device *se_dev, sector_t lba, sector_t nolb,
 	loff_t pos = lba * se_dev->prot_length;
 
 	if (!prot_fd) {
-		pr_err("Unable to locate fd_dev->fd_prot_file\n");
+		target_err("Unable to locate fd_dev->fd_prot_file\n");
 		return -ENODEV;
 	}
 
@@ -501,7 +501,7 @@ fd_do_prot_fill(struct se_device *se_dev, sector_t lba, sector_t nolb,
 		ssize_t ret = kernel_write(prot_fd, buf, len, &pos);
 
 		if (ret != len) {
-			pr_err("vfs_write to prot file failed: %zd\n", ret);
+			target_err("vfs_write to prot file failed: %zd\n", ret);
 			return ret < 0 ? ret : -ENODEV;
 		}
 		prot += ret;
@@ -518,7 +518,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 	buf = (void *)__get_free_page(GFP_KERNEL);
 	if (!buf) {
-		pr_err("Unable to allocate FILEIO prot buf\n");
+		target_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
 	}
 
@@ -556,8 +556,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 					   target_to_linux_sector(dev,  nolb),
 					   GFP_KERNEL);
 		if (ret < 0) {
-			pr_warn("FILEIO: blkdev_issue_discard() failed: %d\n",
-				ret);
+			target_warn("FILEIO: blkdev_issue_discard() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	} else {
@@ -572,7 +571,7 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 		ret = file->f_op->fallocate(file, mode, pos, len);
 		if (ret < 0) {
-			pr_warn("FILEIO: fallocate() failed: %d\n", ret);
+			target_warn("FILEIO: fallocate() failed: %d\n", ret);
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	}
@@ -676,9 +675,9 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * single vfs_[writev,readv] call.
 	 */
 	if (cmd->data_length > FD_MAX_BYTES) {
-		pr_err("FILEIO: Not able to process I/O of %u bytes due to"
-		       "FD_MAX_BYTES: %u iovec count limitation\n",
-			cmd->data_length, FD_MAX_BYTES);
+		target_err("FILEIO: Not able to process I/O of %u bytes due to"
+			   "FD_MAX_BYTES: %u iovec count limitation\n",
+			   cmd->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -726,8 +725,7 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			pr_debug("FILEIO: Referencing Path: %s\n",
-					fd_dev->fd_dev_name);
+			target_debug("FILEIO: Referencing Path: %s\n", fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
 		case Opt_fd_dev_size:
@@ -739,12 +737,13 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 			ret = kstrtoull(arg_p, 0, &fd_dev->fd_dev_size);
 			kfree(arg_p);
 			if (ret < 0) {
-				pr_err("kstrtoull() failed for"
-						" fd_dev_size=\n");
+				target_err("kstrtoull() failed for"
+					   " fd_dev_size=\n");
 				goto out;
 			}
-			pr_debug("FILEIO: Referencing Size: %llu"
-					" bytes\n", fd_dev->fd_dev_size);
+			target_debug("FILEIO: Referencing Size: %llu"
+				     " bytes\n",
+				     fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
 		case Opt_fd_buffered_io:
@@ -752,13 +751,13 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			if (arg != 1) {
-				pr_err("bogus fd_buffered_io=%d value\n", arg);
+				target_err("bogus fd_buffered_io=%d value\n", arg);
 				ret = -EINVAL;
 				goto out;
 			}
 
-			pr_debug("FILEIO: Using buffered I/O"
-				" operations for struct fd_dev\n");
+			target_debug("FILEIO: Using buffered I/O"
+				     " operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_BUFFERED_IO_WCE;
 			break;
@@ -767,13 +766,13 @@ static ssize_t fd_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			if (arg != 1) {
-				pr_err("bogus fd_async_io=%d value\n", arg);
+				target_err("bogus fd_async_io=%d value\n", arg);
 				ret = -EINVAL;
 				goto out;
 			}
 
-			pr_debug("FILEIO: Using async I/O"
-				" operations for struct fd_dev\n");
+			target_debug("FILEIO: Using async I/O"
+				     " operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_HAS_ASYNC_IO;
 			break;
@@ -830,14 +829,14 @@ static int fd_init_prot(struct se_device *dev)
 	char buf[FD_MAX_DEV_PROT_NAME];
 
 	if (!file) {
-		pr_err("Unable to locate fd_dev->fd_file\n");
+		target_err("Unable to locate fd_dev->fd_file\n");
 		return -ENODEV;
 	}
 
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
-		pr_err("FILEIO Protection emulation only supported on"
-		       " !S_ISBLK\n");
+		target_err("FILEIO Protection emulation only supported on"
+			   " !S_ISBLK\n");
 		return -ENOSYS;
 	}
 
@@ -849,7 +848,7 @@ static int fd_init_prot(struct se_device *dev)
 
 	prot_file = filp_open(buf, flags, 0600);
 	if (IS_ERR(prot_file)) {
-		pr_err("filp_open(%s) failed\n", buf);
+		target_err("filp_open(%s) failed\n", buf);
 		ret = PTR_ERR(prot_file);
 		return ret;
 	}
@@ -865,19 +864,18 @@ static int fd_format_prot(struct se_device *dev)
 	int ret;
 
 	if (!dev->dev_attrib.pi_prot_type) {
-		pr_err("Unable to format_prot while pi_prot_type == 0\n");
+		target_err("Unable to format_prot while pi_prot_type == 0\n");
 		return -ENODEV;
 	}
 
 	buf = vzalloc(unit_size);
 	if (!buf) {
-		pr_err("Unable to allocate FILEIO prot buf\n");
+		target_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
 	}
 
-	pr_debug("Using FILEIO prot_length: %llu\n",
-		 (unsigned long long)(dev->transport->get_blocks(dev) + 1) *
-					dev->prot_length);
+	target_debug("Using FILEIO prot_length: %llu\n",
+		     (unsigned long long)(dev->transport->get_blocks(dev) + 1) * dev->prot_length);
 
 	ret = fd_do_prot_fill(dev, 0, dev->transport->get_blocks(dev) + 1,
 			      buf, unit_size);
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index d508b343ba7b..02501fd45b24 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -47,7 +47,7 @@ int transport_backend_register(const struct target_backend_ops *ops)
 	mutex_lock(&backend_mutex);
 	list_for_each_entry(old, &backend_list, list) {
 		if (!strcmp(old->ops->name, ops->name)) {
-			pr_err("backend %s already registered.\n", ops->name);
+			target_err("backend %s already registered.\n", ops->name);
 			mutex_unlock(&backend_mutex);
 			kfree(tb);
 			return -EEXIST;
@@ -57,8 +57,8 @@ int transport_backend_register(const struct target_backend_ops *ops)
 	list_add_tail(&tb->list, &backend_list);
 	mutex_unlock(&backend_mutex);
 
-	pr_debug("TCM: Registered subsystem plugin: %s struct module: %p\n",
-			ops->name, ops->owner);
+	target_debug("TCM: Registered subsystem plugin: %s struct module: %p\n", ops->name,
+		     ops->owner);
 	return 0;
 }
 EXPORT_SYMBOL(transport_backend_register);
@@ -113,7 +113,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 
 	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
 	if (!hba) {
-		pr_err("Unable to allocate struct se_hba\n");
+		target_err("Unable to allocate struct se_hba\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -138,8 +138,9 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	list_add_tail(&hba->hba_node, &hba_list);
 	spin_unlock(&hba_lock);
 
-	pr_debug("CORE_HBA[%d] - Attached HBA to Generic Target"
-			" Core\n", hba->hba_id);
+	target_debug("CORE_HBA[%d] - Attached HBA to Generic Target"
+		     " Core\n",
+		     hba->hba_id);
 
 	return hba;
 
@@ -162,8 +163,9 @@ core_delete_hba(struct se_hba *hba)
 	list_del(&hba->hba_node);
 	spin_unlock(&hba_lock);
 
-	pr_debug("CORE_HBA[%d] - Detached HBA from Generic Target"
-			" Core\n", hba->hba_id);
+	target_debug("CORE_HBA[%d] - Detached HBA from Generic Target"
+		     " Core\n",
+		     hba->hba_id);
 
 	module_put(hba->backend->ops->owner);
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index a3e09adc4e76..843f5903e390 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -45,9 +45,9 @@ static inline struct iblock_dev *IBLOCK_DEV(struct se_device *dev)
 
 static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 {
-	pr_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
-		" Generic Target Core Stack %s\n", hba->hba_id,
-		IBLOCK_VERSION, TARGET_CORE_VERSION);
+	target_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
+		     " Generic Target Core Stack %s\n",
+		     hba->hba_id, IBLOCK_VERSION, TARGET_CORE_VERSION);
 	return 0;
 }
 
@@ -61,7 +61,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 
 	ib_dev = kzalloc(sizeof(struct iblock_dev), GFP_KERNEL);
 	if (!ib_dev) {
-		pr_err("Unable to allocate struct iblock_dev\n");
+		target_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
 
@@ -70,7 +70,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	if (!ib_dev->ibd_plug)
 		goto free_dev;
 
-	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
+	target_debug("IBLOCK: Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
 
@@ -99,18 +99,17 @@ static int iblock_configure_device(struct se_device *dev)
 	int ret;
 
 	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
-		pr_err("Missing udev_path= parameters for IBLOCK\n");
+		target_err("Missing udev_path= parameters for IBLOCK\n");
 		return -EINVAL;
 	}
 
 	ret = bioset_init(&ib_dev->ibd_bio_set, IBLOCK_BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 	if (ret) {
-		pr_err("IBLOCK: Unable to create bioset\n");
+		target_err("IBLOCK: Unable to create bioset\n");
 		goto out;
 	}
 
-	pr_debug( "IBLOCK: Claiming struct block_device: %s\n",
-			ib_dev->ibd_udev_path);
+	target_debug("IBLOCK: Claiming struct block_device: %s\n", ib_dev->ibd_udev_path);
 
 	if (!ib_dev->ibd_readonly)
 		mode |= BLK_OPEN_WRITE;
@@ -153,8 +152,8 @@ static int iblock_configure_device(struct se_device *dev)
 
 	switch (bi->csum_type) {
 	case BLK_INTEGRITY_CSUM_IP:
-		pr_err("IBLOCK export of blk_integrity: %s not supported\n",
-			blk_integrity_profile_name(bi));
+		target_err("IBLOCK export of blk_integrity: %s not supported\n",
+			   blk_integrity_profile_name(bi));
 		ret = -ENOSYS;
 		goto out_blkdev_put;
 	case BLK_INTEGRITY_CSUM_CRC:
@@ -171,12 +170,12 @@ static int iblock_configure_device(struct se_device *dev)
 		struct bio_set *bs = &ib_dev->ibd_bio_set;
 
 		if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
-			pr_err("Unable to allocate bioset for PI\n");
+			target_err("Unable to allocate bioset for PI\n");
 			ret = -ENOMEM;
 			goto out_blkdev_put;
 		}
-		pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
-			 &bs->bio_integrity_pool);
+		target_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
+			     &bs->bio_integrity_pool);
 	}
 
 	dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
@@ -344,7 +343,7 @@ static void iblock_bio_done(struct bio *bio)
 	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
-		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
+		target_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
@@ -370,7 +369,7 @@ static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
 	bio = bio_alloc_bioset(ib_dev->ibd_bd, bio_max_segs(sg_num), opf,
 			       GFP_NOIO, &ib_dev->ibd_bio_set);
 	if (!bio) {
-		pr_err("Unable to allocate memory for bio\n");
+		target_err("Unable to allocate memory for bio\n");
 		return NULL;
 	}
 
@@ -400,7 +399,7 @@ static void iblock_end_io_flush(struct bio *bio)
 	struct se_cmd *cmd = bio->bi_private;
 
 	if (bio->bi_status)
-		pr_err("IBLOCK: cache flush failed: %d\n", bio->bi_status);
+		target_err("IBLOCK: cache flush failed: %d\n", bio->bi_status);
 
 	if (cmd) {
 		if (bio->bi_status)
@@ -451,7 +450,7 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 				   target_to_linux_sector(dev,  nolb),
 				   GFP_KERNEL);
 	if (ret < 0) {
-		pr_err("blkdev_issue_discard() failed: %d\n", ret);
+		target_err("blkdev_issue_discard() failed: %d\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -505,8 +504,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 					sbc_get_write_same_sectors(cmd));
 
 	if (cmd->prot_op) {
-		pr_err("WRITE_SAME: Protection information with IBLOCK"
-		       " backends not supported\n");
+		target_err("WRITE_SAME: Protection information with IBLOCK"
+			   " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -517,9 +516,9 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    sg->length != cmd->se_dev->dev_attrib.block_size) {
-		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			" block_size: %u\n", cmd->t_data_nents, sg->length,
-			cmd->se_dev->dev_attrib.block_size);
+		target_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
+			   " block_size: %u\n",
+			   cmd->t_data_nents, sg->length, cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -605,8 +604,8 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_udev_path:
 			if (ib_dev->ibd_bd) {
-				pr_err("Unable to set udev_path= while"
-					" ib_dev->ibd_bd exists\n");
+				target_err("Unable to set udev_path= while"
+					   " ib_dev->ibd_bd exists\n");
 				ret = -EEXIST;
 				goto out;
 			}
@@ -615,8 +614,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			pr_debug("IBLOCK: Referencing UDEV path: %s\n",
-					ib_dev->ibd_udev_path);
+			target_debug("IBLOCK: Referencing UDEV path: %s\n", ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
 			break;
 		case Opt_readonly:
@@ -628,12 +626,12 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 			ret = kstrtoul(arg_p, 0, &tmp_readonly);
 			kfree(arg_p);
 			if (ret < 0) {
-				pr_err("kstrtoul() failed for"
-						" readonly=\n");
+				target_err("kstrtoul() failed for"
+					   " readonly=\n");
 				goto out;
 			}
 			ib_dev->ibd_readonly = tmp_readonly;
-			pr_debug("IBLOCK: readonly: %d\n", ib_dev->ibd_readonly);
+			target_debug("IBLOCK: readonly: %d\n", ib_dev->ibd_readonly);
 			break;
 		case Opt_force:
 			break;
@@ -685,13 +683,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 
 	bi = bdev_get_integrity(ib_dev->ibd_bd);
 	if (!bi) {
-		pr_err("Unable to locate bio_integrity\n");
+		target_err("Unable to locate bio_integrity\n");
 		return -ENODEV;
 	}
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, bio_max_segs(cmd->t_prot_nents));
 	if (IS_ERR(bip)) {
-		pr_err("Unable to allocate bio_integrity_payload\n");
+		target_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
@@ -699,8 +697,8 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 	bip_set_seed(bip, bio->bi_iter.bi_sector >>
 				  (bi->interval_exp - SECTOR_SHIFT));
 
-	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
-		 (unsigned long long)bip->bip_iter.bi_sector);
+	target_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
+		     (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
 	while (resid > 0 && sg_miter_next(miter)) {
@@ -709,13 +707,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		rc = bio_integrity_add_page(bio, miter->page, len,
 					    offset_in_page(miter->addr));
 		if (rc != len) {
-			pr_err("bio_integrity_add_page() failed; %d\n", rc);
+			target_err("bio_integrity_add_page() failed; %d\n", rc);
 			sg_miter_stop(miter);
 			return -ENOMEM;
 		}
 
-		pr_debug("Added bio integrity page: %p length: %zu offset: %lu\n",
-			  miter->page, len, offset_in_page(miter->addr));
+		target_debug("Added bio integrity page: %p length: %zu offset: %lu\n", miter->page,
+			     len, offset_in_page(miter->addr));
 
 		resid -= len;
 		if (len < miter->length)
@@ -854,7 +852,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	int ret;
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -862,20 +860,20 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	case PRO_REGISTER:
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
 		if (!ops->pr_register) {
-			pr_err("block device does not support pr_register.\n");
+			target_err("block device does not support pr_register.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
 		/* The block layer pr ops always enables aptpl */
 		if (!aptpl)
-			pr_info("APTPL not set by initiator, but will be used.\n");
+			target_info("APTPL not set by initiator, but will be used.\n");
 
 		ret = ops->pr_register(bdev, key, sa_key,
 				sa == PRO_REGISTER ? 0 : PR_FL_IGNORE_KEY);
 		break;
 	case PRO_RESERVE:
 		if (!ops->pr_reserve) {
-			pr_err("block_device does not support pr_reserve.\n");
+			target_err("block_device does not support pr_reserve.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -883,7 +881,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_CLEAR:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_clear.\n");
+			target_err("block_device does not support pr_clear.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -892,7 +890,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_preempt.\n");
+			target_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -902,14 +900,14 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_RELEASE:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_pclear.\n");
+			target_err("block_device does not support pr_pclear.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
 		ret = ops->pr_release(bdev, key, scsi_pr_type_to_block(type));
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		target_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -975,12 +973,12 @@ static sense_reason_t iblock_pr_read_keys(struct se_cmd *cmd,
 	sense_reason_t ret;
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (!ops->pr_read_keys) {
-		pr_err("Block device does not support read_keys.\n");
+		target_err("Block device does not support read_keys.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -1042,12 +1040,12 @@ static sense_reason_t iblock_pr_read_reservation(struct se_cmd *cmd,
 	struct pr_held_reservation rsv = { };
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (!ops->pr_read_reservation) {
-		pr_err("Block device does not support read_keys.\n");
+		target_err("Block device does not support read_keys.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -1089,7 +1087,7 @@ static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
 		ret = iblock_pr_read_reservation(cmd, param_data);
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
+		target_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 80b7d85030d0..a2d0bc1da2bd 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -178,9 +178,9 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 	}
 
 	if (conflict) {
-		pr_err("Received legacy SPC-2 RESERVE/RELEASE"
-			" while active SPC-3 registrations exist,"
-			" returning RESERVATION_CONFLICT\n");
+		target_err("Received legacy SPC-2 RESERVE/RELEASE"
+			   " while active SPC-3 registrations exist,"
+			   " returning RESERVATION_CONFLICT\n");
 		return -EBUSY;
 	}
 
@@ -225,11 +225,10 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 
 	target_release_reservation(dev);
 	tpg = sess->se_tpg;
-	pr_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
-		" MAPPED LUN: %llu for %s\n",
-		tpg->se_tpg_tfo->fabric_name,
-		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
-		sess->se_node_acl->initiatorname);
+	target_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
+		     " MAPPED LUN: %llu for %s\n",
+		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
+		     sess->se_node_acl->initiatorname);
 
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
@@ -249,7 +248,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
-		pr_err("LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
+		target_err("LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	/*
@@ -269,15 +268,14 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->reservation_holder &&
 	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
-		pr_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
-			tpg->se_tpg_tfo->fabric_name);
-		pr_err("Original reserver LUN: %llu %s\n",
-			cmd->se_lun->unpacked_lun,
-			dev->reservation_holder->se_node_acl->initiatorname);
-		pr_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
-			" from %s \n", cmd->se_lun->unpacked_lun,
-			cmd->orig_fe_lun,
-			sess->se_node_acl->initiatorname);
+		target_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
+			   tpg->se_tpg_tfo->fabric_name);
+		target_err("Original reserver LUN: %llu %s\n", cmd->se_lun->unpacked_lun,
+			   dev->reservation_holder->se_node_acl->initiatorname);
+		target_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
+			   " from %s \n",
+			   cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
+			   sess->se_node_acl->initiatorname);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_unlock;
 	}
@@ -288,10 +286,10 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	pr_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu"
-		" for %s\n", tpg->se_tpg_tfo->fabric_name,
-		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
-		sess->se_node_acl->initiatorname);
+	target_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu"
+		     " for %s\n",
+		     tpg->se_tpg_tfo->fabric_name, cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
+		     sess->se_node_acl->initiatorname);
 
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
@@ -413,8 +411,9 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			ret = (registered_nexus) ? 0 : 1;
 			break;
 		default:
-			pr_err("Unknown PERSISTENT_RESERVE_OUT service"
-				" action: 0x%02x\n", cdb[1] & 0x1f);
+			target_err("Unknown PERSISTENT_RESERVE_OUT service"
+				   " action: 0x%02x\n",
+				   cdb[1] & 0x1f);
 			return -EINVAL;
 		}
 		break;
@@ -460,8 +459,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			ret = 0; /* Allowed */
 			break;
 		default:
-			pr_err("Unknown MI Service Action: 0x%02x\n",
-				(cdb[1] & 0x1f));
+			target_err("Unknown MI Service Action: 0x%02x\n", (cdb[1] & 0x1f));
 			return -EINVAL;
 		}
 		break;
@@ -485,9 +483,9 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 	 * statement.
 	 */
 	if (!ret && !other_cdb) {
-		pr_debug("Allowing explicit CDB: 0x%02x for %s"
-			" reservation holder\n", cdb[0],
-			core_scsi3_pr_dump_type(pr_reg_type));
+		target_debug("Allowing explicit CDB: 0x%02x for %s"
+			     " reservation holder\n",
+			     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
 		return ret;
 	}
@@ -500,11 +498,11 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			/*
 			 * Conflict for write exclusive
 			 */
-			pr_debug("%s Conflict for unregistered nexus"
-				" %s CDB: 0x%02x to %s reservation\n",
-				transport_dump_cmd_direction(cmd),
-				se_sess->se_node_acl->initiatorname, cdb[0],
-				core_scsi3_pr_dump_type(pr_reg_type));
+			target_debug("%s Conflict for unregistered nexus"
+				     " %s CDB: 0x%02x to %s reservation\n",
+				     transport_dump_cmd_direction(cmd),
+				     se_sess->se_node_acl->initiatorname, cdb[0],
+				     core_scsi3_pr_dump_type(pr_reg_type));
 			return 1;
 		} else {
 			/*
@@ -518,10 +516,10 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 */
 
 			if (!registered_nexus) {
-				pr_debug("Allowing implicit CDB: 0x%02x"
-					" for %s reservation on unregistered"
-					" nexus\n", cdb[0],
-					core_scsi3_pr_dump_type(pr_reg_type));
+				target_debug("Allowing implicit CDB: 0x%02x"
+					     " for %s reservation on unregistered"
+					     " nexus\n",
+					     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 			}
 
 			return 0;
@@ -533,9 +531,9 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 * allow commands from registered nexuses.
 			 */
 
-			pr_debug("Allowing implicit CDB: 0x%02x for %s"
-				" reservation\n", cdb[0],
-				core_scsi3_pr_dump_type(pr_reg_type));
+			target_debug("Allowing implicit CDB: 0x%02x for %s"
+				     " reservation\n",
+				     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
 			return 0;
 		}
@@ -545,18 +543,18 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
                 * from all registrants.
                 */
                if (cmd->data_direction == DMA_FROM_DEVICE) {
-                       pr_debug("Allowing READ CDB: 0x%02x for %s"
-                               " reservation\n", cdb[0],
-                               core_scsi3_pr_dump_type(pr_reg_type));
+			target_debug("Allowing READ CDB: 0x%02x for %s"
+				     " reservation\n",
+				     cdb[0], core_scsi3_pr_dump_type(pr_reg_type));
 
                        return 0;
                }
 	}
-	pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
-		" for %s reservation\n", transport_dump_cmd_direction(cmd),
-		(registered_nexus) ? "" : "un",
-		se_sess->se_node_acl->initiatorname, cdb[0],
-		core_scsi3_pr_dump_type(pr_reg_type));
+	target_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
+		     " for %s reservation\n",
+		     transport_dump_cmd_direction(cmd), (registered_nexus) ? "" : "un",
+		     se_sess->se_node_acl->initiatorname, cdb[0],
+		     core_scsi3_pr_dump_type(pr_reg_type));
 
 	return 1; /* Conflict by default */
 }
@@ -628,7 +626,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
 	if (!pr_reg) {
-		pr_err("Unable to allocate struct t10_pr_registration\n");
+		target_err("Unable to allocate struct t10_pr_registration\n");
 		return NULL;
 	}
 
@@ -654,8 +652,8 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 		pr_reg->pr_reg_deve = target_nacl_find_deve(nacl, mapped_lun);
 		if (!pr_reg->pr_reg_deve) {
 			rcu_read_unlock();
-			pr_err("Unable to locate PR deve %s mapped_lun: %llu\n",
-				nacl->initiatorname, mapped_lun);
+			target_err("Unable to locate PR deve %s mapped_lun: %llu\n",
+				   nacl->initiatorname, mapped_lun);
 			kmem_cache_free(t10_pr_reg_cache, pr_reg);
 			return NULL;
 		}
@@ -771,8 +769,8 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 */
 			ret = core_scsi3_lunacl_depend_item(deve_tmp);
 			if (ret < 0) {
-				pr_err("core_scsi3_lunacl_depend"
-						"_item() failed\n");
+				target_err("core_scsi3_lunacl_depend"
+					   "_item() failed\n");
 				percpu_ref_put(&lun_tmp->lun_ref);
 				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
@@ -835,13 +833,13 @@ int core_scsi3_alloc_aptpl_registration(
 	struct t10_pr_registration *pr_reg;
 
 	if (!i_port || !t_port || !sa_res_key) {
-		pr_err("Illegal parameters for APTPL registration\n");
+		target_err("Illegal parameters for APTPL registration\n");
 		return -EINVAL;
 	}
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
 	if (!pr_reg) {
-		pr_err("Unable to allocate struct t10_pr_registration\n");
+		target_err("Unable to allocate struct t10_pr_registration\n");
 		return -ENOMEM;
 	}
 
@@ -884,8 +882,9 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_res_holder = res_holder;
 
 	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);
-	pr_debug("SPC-3 PR APTPL Successfully added registration%s from"
-			" metadata\n", (res_holder) ? "+reservation" : "");
+	target_debug("SPC-3 PR APTPL Successfully added registration%s from"
+		     " metadata\n",
+		     (res_holder) ? "+reservation" : "");
 	return 0;
 }
 
@@ -903,14 +902,12 @@ static void core_scsi3_aptpl_reserve(
 	dev->dev_pr_res_holder = pr_reg;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	pr_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created"
-		" new reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tpg->se_tpg_tfo->fabric_name,
-		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
-		tpg->se_tpg_tfo->fabric_name, node_acl->initiatorname,
-		i_buf);
+	target_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created"
+		     " new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		     tpg->se_tpg_tfo->fabric_name, core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+		     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	target_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n", tpg->se_tpg_tfo->fabric_name,
+		     node_acl->initiatorname, i_buf);
 }
 
 static void __core_scsi3_add_registration(struct se_device *, struct se_node_acl *,
@@ -959,8 +956,9 @@ static int __core_scsi3_check_aptpl_registration(
 			rcu_read_lock();
 			pr_reg->pr_reg_deve = target_nacl_find_deve(nacl, mapped_lun);
 			if (!pr_reg->pr_reg_deve) {
-				pr_err("Unable to locate PR APTPL %s mapped_lun:"
-					" %llu\n", nacl->initiatorname, mapped_lun);
+				target_err("Unable to locate PR APTPL %s mapped_lun:"
+					   " %llu\n",
+					   nacl->initiatorname, mapped_lun);
 				rcu_read_unlock();
 				continue;
 			}
@@ -1023,22 +1021,20 @@ static void __core_scsi3_dump_registration(
 
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		" Node: %s%s\n", tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
-		"_AND_MOVE" : (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
-		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname,
-		i_buf);
-	pr_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
-		 tfo->fabric_name, tfo->tpg_get_wwn(se_tpg),
-		tfo->tpg_get_tag(se_tpg));
-	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		" Port(s)\n",  tfo->fabric_name,
-		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
-		dev->transport->name);
-	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x  APTPL: %d\n", tfo->fabric_name,
-		pr_reg->pr_res_key, pr_reg->pr_res_generation,
-		pr_reg->pr_reg_aptpl);
+	target_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
+		     " Node: %s%s\n", tfo->fabric_name, (register_type == REGISTER_AND_MOVE) ?
+		     "_AND_MOVE" : (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
+		     "_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname, i_buf);
+	target_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n", tfo->fabric_name,
+		     tfo->tpg_get_wwn(se_tpg), tfo->tpg_get_tag(se_tpg));
+	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
+		     " Port(s)\n",
+		     tfo->fabric_name, (pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
+		     dev->transport->name);
+	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
+		     " 0x%08x  APTPL: %d\n",
+		     tfo->fabric_name, pr_reg->pr_res_key, pr_reg->pr_res_generation,
+		     pr_reg->pr_reg_aptpl);
 }
 
 static void __core_scsi3_add_registration(
@@ -1256,10 +1252,11 @@ static int core_scsi3_check_implicit_release(
 		  (!strcmp(pr_res_holder->pr_reg_nacl->initiatorname,
 			  pr_reg->pr_reg_nacl->initiatorname)) &&
 		  (pr_res_holder->pr_res_key == pr_reg->pr_res_key)) {
-		pr_err("SPC-3 PR: Unable to perform ALL_TG_PT=1"
-			" UNREGISTER while existing reservation with matching"
-			" key 0x%016Lx is present from another SCSI Initiator"
-			" Port\n", pr_reg->pr_res_key);
+		target_err("SPC-3 PR: Unable to perform ALL_TG_PT=1"
+			   " UNREGISTER while existing reservation with matching"
+			   " key 0x%016Lx is present from another SCSI Initiator"
+			   " Port\n",
+			   pr_reg->pr_res_key);
 		ret = -EPERM;
 	}
 	spin_unlock(&dev->dev_reservation_lock);
@@ -1303,8 +1300,7 @@ static void __core_scsi3_free_registration(
 	 * count back to zero, and we release *pr_reg.
 	 */
 	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
-		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
-				tfo->fabric_name);
+		target_debug("SPC-3 PR [%s] waiting for pr_res_holders\n", tfo->fabric_name);
 		cpu_relax();
 	}
 
@@ -1315,17 +1311,16 @@ static void __core_scsi3_free_registration(
 	rcu_read_unlock();
 
 	spin_lock(&pr_tmpl->registration_lock);
-	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
-		" Node: %s%s\n", tfo->fabric_name,
-		pr_reg->pr_reg_nacl->initiatorname,
-		i_buf);
-	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		" Port(s)\n", tfo->fabric_name,
-		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
-		dev->transport->name);
-	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x\n", tfo->fabric_name, pr_reg->pr_res_key,
-		pr_reg->pr_res_generation);
+	target_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
+		     " Node: %s%s\n",
+		     tfo->fabric_name, pr_reg->pr_reg_nacl->initiatorname, i_buf);
+	target_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
+		     " Port(s)\n",
+		     tfo->fabric_name, (pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
+		     dev->transport->name);
+	target_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
+		     " 0x%08x\n",
+		     tfo->fabric_name, pr_reg->pr_res_key, pr_reg->pr_res_generation);
 
 	if (!preempt_and_abort_list) {
 		pr_reg->pr_reg_deve = NULL;
@@ -1491,7 +1486,7 @@ core_scsi3_decode_spec_i_port(
 	 */
 	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder), GFP_KERNEL);
 	if (!tidh_new) {
-		pr_err("Unable to allocate tidh_new\n");
+		target_err("Unable to allocate tidh_new\n");
 		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 	}
 	INIT_LIST_HEAD(&tidh_new->dest_list);
@@ -1519,8 +1514,9 @@ core_scsi3_decode_spec_i_port(
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
-		pr_warn("SPC-PR: Received PR OUT parameter list"
-			" length too small: %u\n", cmd->data_length);
+		target_warn("SPC-PR: Received PR OUT parameter list"
+			    " length too small: %u\n",
+			    cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -1539,9 +1535,9 @@ core_scsi3_decode_spec_i_port(
 	tpdl = get_unaligned_be32(&buf[24]);
 
 	if ((tpdl + 28) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header"
-			" does not equal CDB data_length: %u\n", tpdl,
-			cmd->data_length);
+		target_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header"
+			   " does not equal CDB data_length: %u\n",
+			   tpdl, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_unmap;
 	}
@@ -1583,8 +1579,8 @@ core_scsi3_decode_spec_i_port(
 			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
 			    dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
-				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
-					i_str);
+				target_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
+					    i_str);
 				ret = TCM_INVALID_PARAMETER_LIST;
 				spin_unlock(&dev->se_port_lock);
 				goto out_unmap;
@@ -1594,8 +1590,8 @@ core_scsi3_decode_spec_i_port(
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
-				pr_err(" core_scsi3_tpg_depend_item()"
-					" for tmp_tpg\n");
+				target_err(" core_scsi3_tpg_depend_item()"
+					   " for tmp_tpg\n");
 				atomic_dec_mb(&tmp_tpg->tpg_pr_ref_count);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -1619,8 +1615,8 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-				pr_err("configfs_depend_item() failed"
-					" for dest_node_acl->acl_group\n");
+				target_err("configfs_depend_item() failed"
+					   " for dest_node_acl->acl_group\n");
 				atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1628,9 +1624,9 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			dest_tpg = tmp_tpg;
-			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
-				dest_tpg->se_tpg_tfo->fabric_name,
-				dest_node_acl->initiatorname, dest_rtpi);
+			target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
+				     dest_tpg->se_tpg_tfo->fabric_name,
+				     dest_node_acl->initiatorname, dest_rtpi);
 
 			spin_lock(&dev->se_port_lock);
 			break;
@@ -1638,20 +1634,21 @@ core_scsi3_decode_spec_i_port(
 		spin_unlock(&dev->se_port_lock);
 
 		if (!dest_tpg) {
-			pr_err("SPC-3 PR SPEC_I_PT: Unable to locate"
-					" dest_tpg\n");
+			target_err("SPC-3 PR SPEC_I_PT: Unable to locate"
+				   " dest_tpg\n");
 			ret = TCM_INVALID_PARAMETER_LIST;
 			goto out_unmap;
 		}
 
-		pr_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
-			" tid_len: %d for %s + %s\n",
-			dest_tpg->se_tpg_tfo->fabric_name, cmd->data_length,
-			tpdl, tid_len, i_str, iport_ptr);
+		target_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
+			     " tid_len: %d for %s + %s\n",
+			     dest_tpg->se_tpg_tfo->fabric_name, cmd->data_length, tpdl, tid_len,
+			     i_str, iport_ptr);
 
 		if (tid_len > tpdl) {
-			pr_err("SPC-3 PR SPEC_I_PT: Illegal tid_len:"
-				" %u for Transport ID: %s\n", tid_len, ptr);
+			target_err("SPC-3 PR SPEC_I_PT: Illegal tid_len:"
+				   " %u for Transport ID: %s\n",
+				   tid_len, ptr);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_INVALID_PARAMETER_LIST;
@@ -1665,9 +1662,8 @@ core_scsi3_decode_spec_i_port(
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
 		if (!dest_se_deve) {
-			pr_err("Unable to locate %s dest_se_deve from destination RTPI: %u\n",
-				dest_tpg->se_tpg_tfo->fabric_name,
-				dest_rtpi);
+			target_err("Unable to locate %s dest_se_deve from destination RTPI: %u\n",
+				   dest_tpg->se_tpg_tfo->fabric_name, dest_rtpi);
 
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1676,8 +1672,8 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
-			pr_err("core_scsi3_lunacl_depend_item()"
-					" failed\n");
+			target_err("core_scsi3_lunacl_depend_item()"
+				   " failed\n");
 			kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1685,10 +1681,10 @@ core_scsi3_decode_spec_i_port(
 			goto out_unmap;
 		}
 
-		pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s"
-			" dest_se_deve mapped_lun: %llu\n",
-			dest_tpg->se_tpg_tfo->fabric_name,
-			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
+		target_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s"
+			     " dest_se_deve mapped_lun: %llu\n",
+			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname,
+			     dest_se_deve->mapped_lun);
 
 		/*
 		 * Skip any TransportIDs that already have a registration for
@@ -1714,7 +1710,7 @@ core_scsi3_decode_spec_i_port(
 		tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
 				GFP_KERNEL);
 		if (!tidh_new) {
-			pr_err("Unable to allocate tidh_new\n");
+			target_err("Unable to allocate tidh_new\n");
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1795,11 +1791,11 @@ core_scsi3_decode_spec_i_port(
 		__core_scsi3_add_registration(cmd->se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
-		pr_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
-			" registered Transport ID for Node: %s%s Mapped LUN:"
-			" %llu\n", dest_tpg->se_tpg_tfo->fabric_name,
-			dest_node_acl->initiatorname, i_buf, (dest_se_deve) ?
-			dest_se_deve->mapped_lun : 0);
+		target_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
+			     " registered Transport ID for Node: %s%s Mapped LUN:"
+			     " %llu\n",
+			     dest_tpg->se_tpg_tfo->fabric_name, dest_node_acl->initiatorname, i_buf,
+			     (dest_se_deve) ? dest_se_deve->mapped_lun : 0);
 
 		if (dest_pr_reg == local_pr_reg)
 			continue;
@@ -1912,8 +1908,8 @@ static int core_scsi3_update_aptpl_buf(
 		}
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			pr_err("Unable to update renaming APTPL metadata,"
-			       " reallocating larger buffer\n");
+			target_err("Unable to update renaming APTPL metadata,"
+				   " reallocating larger buffer\n");
 			ret = -EMSGSIZE;
 			goto out;
 		}
@@ -1931,8 +1927,8 @@ static int core_scsi3_update_aptpl_buf(
 			reg_count);
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			pr_err("Unable to update renaming APTPL metadata,"
-			       " reallocating larger buffer\n");
+			target_err("Unable to update renaming APTPL metadata,"
+				   " reallocating larger buffer\n");
 			ret = -EMSGSIZE;
 			goto out;
 		}
@@ -1969,8 +1965,9 @@ static int __core_scsi3_write_aptpl_to_file(
 
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file)) {
-		pr_err("filp_open(%s) for APTPL metadata"
-			" failed\n", path);
+		target_err("filp_open(%s) for APTPL metadata"
+			   " failed\n",
+			   path);
 		kfree(path);
 		return PTR_ERR(file);
 	}
@@ -1980,7 +1977,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	ret = kernel_write(file, buf, pr_aptpl_buf_len, &pos);
 
 	if (ret < 0)
-		pr_debug("Error writing APTPL metadata file: %s\n", path);
+		target_debug("Error writing APTPL metadata file: %s\n", path);
 	fput(file);
 	kfree(path);
 
@@ -2001,7 +1998,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 
 		rc = __core_scsi3_write_aptpl_to_file(dev, null_buf);
 		dev->t10_pr.pr_aptpl_active = 0;
-		pr_debug("SPC-3 PR: Set APTPL Bit Deactivated\n");
+		target_debug("SPC-3 PR: Set APTPL Bit Deactivated\n");
 
 		if (rc)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2022,13 +2019,13 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 
 	rc = __core_scsi3_write_aptpl_to_file(dev, buf);
 	if (rc != 0) {
-		pr_err("SPC-3 PR: Could not update APTPL\n");
+		target_err("SPC-3 PR: Could not update APTPL\n");
 		vfree(buf);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	dev->t10_pr.pr_aptpl_active = 1;
 	vfree(buf);
-	pr_debug("SPC-3 PR: Set APTPL Bit Activated\n");
+	target_debug("SPC-3 PR: Set APTPL Bit Activated\n");
 	return 0;
 }
 
@@ -2048,7 +2045,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	int pr_holder = 0, type;
 
 	if (!se_sess || !se_lun) {
-		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		target_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
@@ -2064,8 +2061,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
 		if (res_key) {
-			pr_warn("SPC-3 PR: Reservation Key non-zero"
-				" for SA REGISTER, returning CONFLICT\n");
+			target_warn("SPC-3 PR: Reservation Key non-zero"
+				    " for SA REGISTER, returning CONFLICT\n");
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
@@ -2085,8 +2082,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					NULL, cmd->orig_fe_lun, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					register_type, 0)) {
-				pr_err("Unable to allocate"
-					" struct t10_pr_registration\n");
+				target_err("Unable to allocate"
+					   " struct t10_pr_registration\n");
 				return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 			}
 		} else {
@@ -2109,18 +2106,18 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	/* ok, existing registration */
 
 	if ((register_type == REGISTER) && (res_key != pr_reg->pr_res_key)) {
-		pr_err("SPC-3 PR REGISTER: Received"
-		       " res_key: 0x%016Lx does not match"
-		       " existing SA REGISTER res_key:"
-		       " 0x%016Lx\n", res_key,
-		       pr_reg->pr_res_key);
+		target_err("SPC-3 PR REGISTER: Received"
+			   " res_key: 0x%016Lx does not match"
+			   " existing SA REGISTER res_key:"
+			   " 0x%016Lx\n",
+			   res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
 	}
 
 	if (spec_i_pt) {
-		pr_err("SPC-3 PR REGISTER: SPEC_I_PT"
-			" set on a registered nexus\n");
+		target_err("SPC-3 PR REGISTER: SPEC_I_PT"
+			   " set on a registered nexus\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -2130,9 +2127,9 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	 * must also set ALL_TG_PT=1 in the incoming PROUT.
 	 */
 	if (pr_reg->pr_reg_all_tg_pt && !all_tg_pt) {
-		pr_err("SPC-3 PR REGISTER: ALL_TG_PT=1"
-			" registration exists, but ALL_TG_PT=1 bit not"
-			" present in received PROUT\n");
+		target_err("SPC-3 PR REGISTER: ALL_TG_PT=1"
+			   " registration exists, but ALL_TG_PT=1 bit not"
+			   " present in received PROUT\n");
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
 	}
@@ -2148,12 +2145,12 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		 */
 		pr_reg->pr_res_generation = core_scsi3_pr_generation(cmd->se_dev);
 		pr_reg->pr_res_key = sa_res_key;
-		pr_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
-			 " Key for %s to: 0x%016Lx PRgeneration:"
-			 " 0x%08x\n", cmd->se_tfo->fabric_name,
-			 (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ? "_AND_IGNORE_EXISTING_KEY" : "",
-			 pr_reg->pr_reg_nacl->initiatorname,
-			 pr_reg->pr_res_key, pr_reg->pr_res_generation);
+		target_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
+			     " Key for %s to: 0x%016Lx PRgeneration:"
+			     " 0x%08x\n", cmd->se_tfo->fabric_name,
+			     (register_type == REGISTER_AND_IGNORE_EXISTING_KEY) ?
+			     "_AND_IGNORE_EXISTING_KEY" : "", pr_reg->pr_reg_nacl->initiatorname,
+			     pr_reg->pr_res_key, pr_reg->pr_res_generation);
 
 	} else {
 		/*
@@ -2269,7 +2266,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	sense_reason_t ret;
 
 	if (!se_sess || !se_lun) {
-		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		target_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2278,8 +2275,8 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		pr_err("SPC-3 PR: Unable to locate"
-			" PR_REGISTERED *pr_reg for RESERVE\n");
+		target_err("SPC-3 PR: Unable to locate"
+			   " PR_REGISTERED *pr_reg for RESERVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2292,9 +2289,10 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * 	 registered with the logical unit for the I_T nexus; and
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		pr_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
-			" does not match existing SA REGISTER res_key:"
-			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		target_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
+			   " does not match existing SA REGISTER res_key:"
+			   " 0x%016Lx\n",
+			   res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
 	}
@@ -2309,7 +2307,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * and that persistent reservation has a scope of LU_SCOPE.
 	 */
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		target_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -2333,13 +2331,12 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		 */
 		if (!is_reservation_holder(pr_res_holder, pr_reg)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			pr_err("SPC-3 PR: Attempted RESERVE from"
-				" [%s]: %s while reservation already held by"
-				" [%s]: %s, returning RESERVATION_CONFLICT\n",
-				cmd->se_tfo->fabric_name,
-				se_sess->se_node_acl->initiatorname,
-				pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				pr_res_holder->pr_reg_nacl->initiatorname);
+			target_err("SPC-3 PR: Attempted RESERVE from"
+				   " [%s]: %s while reservation already held by"
+				   " [%s]: %s, returning RESERVATION_CONFLICT\n",
+				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
+				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+				   pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2355,14 +2352,13 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			pr_err("SPC-3 PR: Attempted RESERVE from"
-				" [%s]: %s trying to change TYPE and/or SCOPE,"
-				" while reservation already held by [%s]: %s,"
-				" returning RESERVATION_CONFLICT\n",
-				cmd->se_tfo->fabric_name,
-				se_sess->se_node_acl->initiatorname,
-				pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-				pr_res_holder->pr_reg_nacl->initiatorname);
+			target_err("SPC-3 PR: Attempted RESERVE from"
+				   " [%s]: %s trying to change TYPE and/or SCOPE,"
+				   " while reservation already held by [%s]: %s,"
+				   " returning RESERVATION_CONFLICT\n",
+				   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
+				   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+				   pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = TCM_RESERVATION_CONFLICT;
@@ -2392,14 +2388,12 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	dev->dev_pr_res_holder = pr_reg;
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
-	pr_debug("SPC-3 PR [%s] Service Action: RESERVE created new"
-		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
-			cmd->se_tfo->fabric_name,
-			se_sess->se_node_acl->initiatorname,
-			i_buf);
+	target_debug("SPC-3 PR [%s] Service Action: RESERVE created new"
+		     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		     cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
+		     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	target_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n", cmd->se_tfo->fabric_name,
+		     se_sess->se_node_acl->initiatorname, i_buf);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active)
@@ -2424,8 +2418,9 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
 		return core_scsi3_pro_reserve(cmd, type, scope, res_key);
 	default:
-		pr_err("SPC-3 PR: Unknown Service Action RESERVE Type:"
-			" 0x%02x\n", type);
+		target_err("SPC-3 PR: Unknown Service Action RESERVE Type:"
+			   " 0x%02x\n",
+			   type);
 		return TCM_INVALID_CDB_FIELD;
 	}
 }
@@ -2482,15 +2477,14 @@ static void __core_scsi3_complete_pro_release(
 	spin_unlock(&dev->t10_pr.registration_lock);
 out:
 	if (!dev->dev_pr_res_holder) {
-		pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
-			" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-			tfo->fabric_name, (explicit) ? "explicit" :
-			"implicit", core_scsi3_pr_dump_type(pr_res_type),
-			(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	}
-	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
-		tfo->fabric_name, se_nacl->initiatorname,
-		i_buf);
+		target_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
+			     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+			     tfo->fabric_name, (explicit) ? "explicit" : "implicit",
+			     core_scsi3_pr_dump_type(pr_res_type),
+			     (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	}
+	target_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n", tfo->fabric_name, se_nacl->initiatorname,
+		     i_buf);
 	/*
 	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
 	 */
@@ -2509,7 +2503,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	sense_reason_t ret = 0;
 
 	if (!se_sess || !se_lun) {
-		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		target_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2517,8 +2511,8 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!pr_reg) {
-		pr_err("SPC-3 PR: Unable to locate"
-			" PR_REGISTERED *pr_reg for RELEASE\n");
+		target_err("SPC-3 PR: Unable to locate"
+			   " PR_REGISTERED *pr_reg for RELEASE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2567,9 +2561,10 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	 *	  that is registered with the logical unit for the I_T nexus;
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		pr_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
-			" does not match existing SA REGISTER res_key:"
-			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		target_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
+			   " does not match existing SA REGISTER res_key:"
+			   " 0x%016Lx\n",
+			   res_key, pr_reg->pr_res_key);
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
@@ -2583,14 +2578,13 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-		pr_err("SPC-3 PR RELEASE: Attempted to release"
-			" reservation from [%s]: %s with different TYPE "
-			"and/or SCOPE  while reservation already held by"
-			" [%s]: %s, returning RESERVATION_CONFLICT\n",
-			cmd->se_tfo->fabric_name,
-			se_sess->se_node_acl->initiatorname,
-			pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
-			pr_res_holder->pr_reg_nacl->initiatorname);
+		target_err("SPC-3 PR RELEASE: Attempted to release"
+			   " reservation from [%s]: %s with different TYPE "
+			   "and/or SCOPE  while reservation already held by"
+			   " [%s]: %s, returning RESERVATION_CONFLICT\n",
+			   cmd->se_tfo->fabric_name, se_sess->se_node_acl->initiatorname,
+			   pr_res_nacl->se_tpg->se_tpg_tfo->fabric_name,
+			   pr_res_holder->pr_reg_nacl->initiatorname);
 
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
@@ -2670,8 +2664,8 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!pr_reg_n) {
-		pr_err("SPC-3 PR: Unable to locate"
-			" PR_REGISTERED *pr_reg for CLEAR\n");
+		target_err("SPC-3 PR: Unable to locate"
+			   " PR_REGISTERED *pr_reg for CLEAR\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -2686,10 +2680,11 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	 * 	   that is registered with the logical unit for the I_T nexus.
 	 */
 	if (res_key != pr_reg_n->pr_res_key) {
-		pr_err("SPC-3 PR REGISTER: Received"
-			" res_key: 0x%016Lx does not match"
-			" existing SA REGISTER res_key:"
-			" 0x%016Lx\n", res_key, pr_reg_n->pr_res_key);
+		target_err("SPC-3 PR REGISTER: Received"
+			   " res_key: 0x%016Lx does not match"
+			   " existing SA REGISTER res_key:"
+			   " 0x%016Lx\n",
+			   res_key, pr_reg_n->pr_res_key);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_RESERVATION_CONFLICT;
 	}
@@ -2729,8 +2724,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
-	pr_debug("SPC-3 PR [%s] Service Action: CLEAR complete\n",
-		cmd->se_tfo->fabric_name);
+	target_debug("SPC-3 PR [%s] Service Action: CLEAR complete\n", cmd->se_tfo->fabric_name);
 
 	core_scsi3_update_and_write_aptpl(cmd->se_dev, false);
 
@@ -2765,14 +2759,13 @@ static void __core_scsi3_complete_pro_preempt(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
 
-	pr_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new"
-		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
-		core_scsi3_pr_dump_type(type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
-		tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
-		nacl->initiatorname, i_buf);
+	target_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new"
+		     " reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		     tfo->fabric_name, (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "",
+		     core_scsi3_pr_dump_type(type), (pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	target_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n", tfo->fabric_name,
+		     (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", nacl->initiatorname,
+		     i_buf);
 	/*
 	 * For PREEMPT_AND_ABORT, add the preempting reservation's
 	 * struct t10_pr_registration to the list that will be compared
@@ -2796,7 +2789,7 @@ static void core_scsi3_release_preempt_and_abort(
 		if (pr_reg_holder == pr_reg)
 			continue;
 		if (pr_reg->pr_res_holder) {
-			pr_warn("pr_reg->pr_res_holder still set\n");
+			target_warn("pr_reg->pr_res_holder still set\n");
 			continue;
 		}
 
@@ -2827,9 +2820,9 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg_n) {
-		pr_err("SPC-3 PR: Unable to locate"
-			" PR_REGISTERED *pr_reg for PREEMPT%s\n",
-			(preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "");
+		target_err("SPC-3 PR: Unable to locate"
+			   " PR_REGISTERED *pr_reg for PREEMPT%s\n",
+			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "");
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (pr_reg_n->pr_res_key != res_key) {
@@ -2837,7 +2830,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		return TCM_RESERVATION_CONFLICT;
 	}
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		target_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
@@ -3130,8 +3123,9 @@ core_scsi3_emulate_pro_preempt(struct se_cmd *cmd, int type, int scope,
 		return core_scsi3_pro_preempt(cmd, type, scope, res_key,
 					      sa_res_key, preempt_type);
 	default:
-		pr_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
-			" Type: 0x%02x\n", (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
+		target_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
+			   " Type: 0x%02x\n",
+			   (preempt_type == PREEMPT_AND_ABORT) ? "_AND_ABORT" : "", type);
 		return TCM_INVALID_CDB_FIELD;
 	}
 }
@@ -3160,7 +3154,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	unsigned char proto_ident;
 
 	if (!se_sess || !se_lun) {
-		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		target_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -3175,8 +3169,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!pr_reg) {
-		pr_err("SPC-3 PR: Unable to locate PR_REGISTERED"
-			" *pr_reg for REGISTER_AND_MOVE\n");
+		target_err("SPC-3 PR: Unable to locate PR_REGISTERED"
+			   " *pr_reg for REGISTER_AND_MOVE\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -3184,9 +3178,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * provided during this initiator's I_T nexus registration.
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Received"
-			" res_key: 0x%016Lx does not match existing SA REGISTER"
-			" res_key: 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received"
+			    " res_key: 0x%016Lx does not match existing SA REGISTER"
+			    " res_key: 0x%016Lx\n",
+			    res_key, pr_reg->pr_res_key);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_put_pr_reg;
 	}
@@ -3194,8 +3189,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * The service active reservation key needs to be non zero
 	 */
 	if (!sa_res_key) {
-		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero"
-			" sa_res_key\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero"
+			    " sa_res_key\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3217,9 +3212,9 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	buf = NULL;
 
 	if ((tid_len + 24) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+		target_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
+			   " does not equal CDB data_length: %u\n",
+			   tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3237,8 +3232,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
-			pr_err("core_scsi3_tpg_depend_item() failed"
-				" for dest_se_tpg\n");
+			target_err("core_scsi3_tpg_depend_item() failed"
+				   " for dest_se_tpg\n");
 			atomic_dec_mb(&dest_se_tpg->tpg_pr_ref_count);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
@@ -3250,9 +3245,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_unlock(&dev->se_port_lock);
 
 	if (!dest_se_tpg || !dest_tf_ops) {
-		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
-			" fabric ops from Relative Target Port Identifier:"
-			" %hu\n", rtpi);
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+			   " fabric ops from Relative Target Port Identifier:"
+			   " %hu\n",
+			   rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3264,23 +3260,23 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	}
 	proto_ident = (buf[24] & 0x0f);
 
-	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
-			" 0x%02x\n", proto_ident);
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
+		     " 0x%02x\n",
+		     proto_ident);
 
 	if (proto_ident != dest_se_tpg->proto_id) {
-		pr_err("SPC-3 PR REGISTER_AND_MOVE: Received"
-			" proto_ident: 0x%02x does not match ident: 0x%02x"
-			" from fabric: %s\n", proto_ident,
-			dest_se_tpg->proto_id,
-			dest_tf_ops->fabric_name);
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Received"
+			   " proto_ident: 0x%02x does not match ident: 0x%02x"
+			   " from fabric: %s\n",
+			   proto_ident, dest_se_tpg->proto_id, dest_tf_ops->fabric_name);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
 			&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!initiator_str) {
-		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
-			" initiator_str from Transport ID\n");
+		target_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+			   " initiator_str from Transport ID\n");
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -3288,10 +3284,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
-		" %s\n", dest_tf_ops->fabric_name, (iport_ptr != NULL) ?
-		"port" : "device", initiator_str, (iport_ptr != NULL) ?
-		iport_ptr : "");
+	target_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
+		     " %s\n",
+		     dest_tf_ops->fabric_name, (iport_ptr != NULL) ? "port" : "device",
+		     initiator_str, (iport_ptr != NULL) ? iport_ptr : "");
 	/*
 	 * If a PERSISTENT RESERVE OUT command with a REGISTER AND MOVE service
 	 * action specifies a TransportID that is the same as the initiator port
@@ -3307,17 +3303,17 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		goto after_iport_check;
 
 	if (!iport_ptr || !pr_reg->isid_present_at_reg) {
-		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
-			" matches: %s on received I_T Nexus\n", initiator_str,
-			pr_reg_nacl->initiatorname);
+		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
+			   " matches: %s on received I_T Nexus\n",
+			   initiator_str, pr_reg_nacl->initiatorname);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	if (!strcmp(iport_ptr, pr_reg->pr_reg_isid)) {
-		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
-			" matches: %s %s on received I_T Nexus\n",
-			initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
-			pr_reg->pr_reg_isid);
+		target_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
+			   " matches: %s %s on received I_T Nexus\n",
+			   initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
+			   pr_reg->pr_reg_isid);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -3333,25 +3329,25 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	mutex_unlock(&dest_se_tpg->acl_node_mutex);
 
 	if (!dest_node_acl) {
-		pr_err("Unable to locate %s dest_node_acl for"
-			" TransportID%s\n", dest_tf_ops->fabric_name,
-			initiator_str);
+		target_err("Unable to locate %s dest_node_acl for"
+			   " TransportID%s\n",
+			   dest_tf_ops->fabric_name, initiator_str);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
 	if (core_scsi3_nodeacl_depend_item(dest_node_acl)) {
-		pr_err("core_scsi3_nodeacl_depend_item() for"
-			" dest_node_acl\n");
+		target_err("core_scsi3_nodeacl_depend_item() for"
+			   " dest_node_acl\n");
 		atomic_dec_mb(&dest_node_acl->acl_pr_ref_count);
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
-	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
-		" %s from TransportID\n", dest_tf_ops->fabric_name,
-		dest_node_acl->initiatorname);
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
+		     " %s from TransportID\n",
+		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname);
 
 	/*
 	 * Locate the struct se_dev_entry pointer for the matching RELATIVE TARGET
@@ -3359,24 +3355,25 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!dest_se_deve) {
-		pr_err("Unable to locate %s dest_se_deve from RTPI:"
-			" %hu\n",  dest_tf_ops->fabric_name, rtpi);
+		target_err("Unable to locate %s dest_se_deve from RTPI:"
+			   " %hu\n",
+			   dest_tf_ops->fabric_name, rtpi);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
-		pr_err("core_scsi3_lunacl_depend_item() failed\n");
+		target_err("core_scsi3_lunacl_depend_item() failed\n");
 		kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 
-	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
-		" ACL for dest_se_deve->mapped_lun: %llu\n",
-		dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
-		dest_se_deve->mapped_lun);
+	target_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
+		     " ACL for dest_se_deve->mapped_lun: %llu\n",
+		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
+		     dest_se_deve->mapped_lun);
 
 	/*
 	 * A persistent reservation needs to already existing in order to
@@ -3385,8 +3382,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (!pr_res_holder) {
-		pr_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation"
-			" currently held\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation"
+			    " currently held\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto out;
@@ -3398,8 +3395,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 * 	Register behaviors for a REGISTER AND MOVE service action
 	 */
 	if (!is_reservation_holder(pr_res_holder, pr_reg)) {
-		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
-			" Nexus is not reservation holder\n");
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
+			    " Nexus is not reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
@@ -3415,9 +3412,9 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	 */
 	if ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
-		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move"
-			" reservation for type: %s\n",
-			core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
+		target_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move"
+			    " reservation for type: %s\n",
+			    core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out;
@@ -3492,17 +3489,16 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	pr_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
-		" created new reservation holder TYPE: %s on object RTPI:"
-		" %hu  PRGeneration: 0x%08x\n", dest_tf_ops->fabric_name,
-		core_scsi3_pr_dump_type(type), rtpi,
-		dest_pr_reg->pr_res_generation);
-	pr_debug("SPC-3 PR Successfully moved reservation from"
-		" %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
-		tf_ops->fabric_name, pr_reg_nacl->initiatorname,
-		i_buf, dest_tf_ops->fabric_name,
-		dest_node_acl->initiatorname, (iport_ptr != NULL) ?
-		iport_ptr : "");
+	target_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
+		     " created new reservation holder TYPE: %s on object RTPI:"
+		     " %hu  PRGeneration: 0x%08x\n",
+		     dest_tf_ops->fabric_name, core_scsi3_pr_dump_type(type), rtpi,
+		     dest_pr_reg->pr_res_generation);
+	target_debug("SPC-3 PR Successfully moved reservation from"
+		     " %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
+		     tf_ops->fabric_name, pr_reg_nacl->initiatorname, i_buf,
+		     dest_tf_ops->fabric_name, dest_node_acl->initiatorname,
+		     (iport_ptr != NULL) ? iport_ptr : "");
 	/*
 	 * It is now safe to release configfs group dependencies for destination
 	 * of Transport ID Initiator Device/Port Identifier
@@ -3546,24 +3542,24 @@ target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 
 	if (!cmd->se_sess || !cmd->se_lun) {
-		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		target_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
 	if (!ops->execute_pr_out) {
-		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		target_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	switch (sa) {
 	case PRO_REGISTER_AND_MOVE:
 	case PRO_REPLACE_LOST_RESERVATION:
-		pr_err("SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
+		target_err("SPC-3 PR: PRO_REGISTER_AND_MOVE and PRO_REPLACE_LOST_RESERVATION are not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (spec_i_pt || all_tg_pt) {
-		pr_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
+		target_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -3594,9 +3590,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		pr_err("Received PERSISTENT_RESERVE CDB while legacy"
-			" SPC-2 reservation is held, returning"
-			" RESERVATION_CONFLICT\n");
+		target_err("Received PERSISTENT_RESERVE CDB while legacy"
+			   " SPC-2 reservation is held, returning"
+			   " RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -3608,8 +3604,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (cmd->data_length < 24) {
-		pr_warn("SPC-PR: Received PR OUT parameter list"
-			" length too small: %u\n", cmd->data_length);
+		target_warn("SPC-PR: Received PR OUT parameter list"
+			    " length too small: %u\n",
+			    cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -3668,8 +3665,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 */
 	if (!spec_i_pt && (sa != PRO_REGISTER_AND_MOVE) &&
 	    (cmd->data_length != 24)) {
-		pr_warn("SPC-PR: Received PR OUT illegal parameter"
-			" list length: %u\n", cmd->data_length);
+		target_warn("SPC-PR: Received PR OUT illegal parameter"
+			    " list length: %u\n",
+			    cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -3715,8 +3713,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 				sa_res_key, aptpl, unreg);
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_OUT service"
-			" action: 0x%02x\n", sa);
+		target_err("Unknown PERSISTENT_RESERVE_OUT service"
+			   " action: 0x%02x\n",
+			   sa);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3740,8 +3739,9 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
-		pr_err("PRIN SA READ_KEYS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+		target_err("PRIN SA READ_KEYS SCSI Data Length: %u"
+			   " too small\n",
+			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3795,8 +3795,9 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	u32 add_len = 0;
 
 	if (cmd->data_length < 8) {
-		pr_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+		target_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
+			   " too small\n",
+			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3871,8 +3872,9 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	u16 len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
-		pr_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
-			" %u too small\n", cmd->data_length);
+		target_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
+			   " %u too small\n",
+			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3937,8 +3939,9 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	bool all_reg = false;
 
 	if (cmd->data_length < 8) {
-		pr_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+		target_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
+			   " too small\n",
+			   cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3979,8 +3982,9 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 					&format_code);
 		if (exp_desc_len < 0 ||
 		    exp_desc_len + add_len > cmd->data_length) {
-			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
-				" out of buffer: %d\n", cmd->data_length);
+			target_warn("SPC-3 PRIN READ_FULL_STATUS ran"
+				    " out of buffer: %d\n",
+				    cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec_mb(&pr_reg->pr_res_holders);
 			break;
@@ -4085,18 +4089,17 @@ static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
 	sense_reason_t ret;
 
 	if (cmd->data_length < 8) {
-		pr_err("PRIN SA SCSI Data Length: %u too small\n",
-		       cmd->data_length);
+		target_err("PRIN SA SCSI Data Length: %u too small\n", cmd->data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
 	if (!ops->execute_pr_in) {
-		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		target_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (sa == PRI_READ_FULL_STATUS) {
-		pr_err("SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
+		target_err("SPC-3 PR: PRI_READ_FULL_STATUS is not supported by PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -4126,9 +4129,9 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (cmd->se_dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		pr_err("Received PERSISTENT_RESERVE CDB while legacy"
-			" SPC-2 reservation is held, returning"
-			" RESERVATION_CONFLICT\n");
+		target_err("Received PERSISTENT_RESERVE CDB while legacy"
+			   " SPC-2 reservation is held, returning"
+			   " RESERVATION_CONFLICT\n");
 		return TCM_RESERVATION_CONFLICT;
 	}
 
@@ -4151,8 +4154,9 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		ret = core_scsi3_pri_read_full_status(cmd);
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_IN service"
-			" action: 0x%02x\n", cmd->t_task_cdb[1] & 0x1f);
+		target_err("Unknown PERSISTENT_RESERVE_IN service"
+			   " action: 0x%02x\n",
+			   cmd->t_task_cdb[1] & 0x1f);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index da7017113f92..a697993dbfaa 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -52,7 +52,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	phv = kzalloc(sizeof(struct pscsi_hba_virt), GFP_KERNEL);
 	if (!phv) {
-		pr_err("Unable to allocate struct pscsi_hba_virt\n");
+		target_err("Unable to allocate struct pscsi_hba_virt\n");
 		return -ENOMEM;
 	}
 	phv->phv_host_id = host_id;
@@ -60,11 +60,10 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = phv;
 
-	pr_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
-		" Generic Target Core Stack %s\n", hba->hba_id,
-		PSCSI_VERSION, TARGET_CORE_VERSION);
-	pr_debug("CORE_HBA[%d] - Attached SCSI HBA to Generic\n",
-	       hba->hba_id);
+	target_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
+		     " Generic Target Core Stack %s\n",
+		     hba->hba_id, PSCSI_VERSION, TARGET_CORE_VERSION);
+	target_debug("CORE_HBA[%d] - Attached SCSI HBA to Generic\n", hba->hba_id);
 
 	return 0;
 }
@@ -77,13 +76,14 @@ static void pscsi_detach_hba(struct se_hba *hba)
 	if (scsi_host) {
 		scsi_host_put(scsi_host);
 
-		pr_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from"
-			" Generic Target Core\n", hba->hba_id,
-			(scsi_host->hostt->name) ? (scsi_host->hostt->name) :
-			"Unknown");
+		target_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from"
+			     " Generic Target Core\n",
+			     hba->hba_id,
+			     (scsi_host->hostt->name) ? (scsi_host->hostt->name) : "Unknown");
 	} else
-		pr_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA"
-			" from Generic Target Core\n", hba->hba_id);
+		target_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA"
+			     " from Generic Target Core\n",
+			     hba->hba_id);
 
 	kfree(phv);
 	hba->hba_ptr = NULL;
@@ -103,9 +103,9 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 		phv->phv_lld_host = NULL;
 		phv->phv_mode = PHV_VIRTUAL_HOST_ID;
 
-		pr_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
-			" %s\n", hba->hba_id, (sh->hostt->name) ?
-			(sh->hostt->name) : "Unknown");
+		target_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
+			     " %s\n",
+			     hba->hba_id, (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 
 		scsi_host_put(sh);
 		return 0;
@@ -116,16 +116,17 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
 	if (!sh) {
-		pr_err("pSCSI: Unable to locate SCSI Host for"
-			" phv_host_id: %d\n", phv->phv_host_id);
+		target_err("pSCSI: Unable to locate SCSI Host for"
+			   " phv_host_id: %d\n",
+			   phv->phv_host_id);
 		return -EINVAL;
 	}
 
 	phv->phv_lld_host = sh;
 	phv->phv_mode = PHV_LLD_SCSI_HOST_NO;
 
-	pr_debug("CORE_HBA[%d] - Enabled pSCSI HBA Passthrough %s\n",
-		hba->hba_id, (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
+	target_debug("CORE_HBA[%d] - Enabled pSCSI HBA Passthrough %s\n", hba->hba_id,
+		     (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 
 	return 1;
 }
@@ -240,16 +241,16 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 		page_83 = &buf[off];
 		ident_len = page_83[3];
 		if (!ident_len) {
-			pr_err("page_83[3]: identifier"
-					" length zero!\n");
+			target_err("page_83[3]: identifier"
+				   " length zero!\n");
 			break;
 		}
-		pr_debug("T10 VPD Identifier Length: %d\n", ident_len);
+		target_debug("T10 VPD Identifier Length: %d\n", ident_len);
 
 		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
 		if (!vpd) {
-			pr_err("Unable to allocate memory for"
-					" struct t10_vpd\n");
+			target_err("Unable to allocate memory for"
+				   " struct t10_vpd\n");
 			goto out;
 		}
 		INIT_LIST_HEAD(&vpd->vpd_list);
@@ -290,9 +291,9 @@ static int pscsi_add_device_to_list(struct se_device *dev,
 	if (!sd->queue_depth) {
 		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
 
-		pr_err("Set broken SCSI Device %d:%d:%llu"
-			" queue_depth to %d\n", sd->channel, sd->id,
-				sd->lun, sd->queue_depth);
+		target_err("Set broken SCSI Device %d:%d:%llu"
+			   " queue_depth to %d\n",
+			   sd->channel, sd->id, sd->lun, sd->queue_depth);
 	}
 
 	dev->dev_attrib.hw_block_size =
@@ -335,11 +336,11 @@ static struct se_device *pscsi_alloc_device(struct se_hba *hba,
 
 	pdv = kzalloc(sizeof(struct pscsi_dev_virt), GFP_KERNEL);
 	if (!pdv) {
-		pr_err("Unable to allocate memory for struct pscsi_dev_virt\n");
+		target_err("Unable to allocate memory for struct pscsi_dev_virt\n");
 		return NULL;
 	}
 
-	pr_debug("PSCSI: Allocated pdv: %p for %s\n", pdv, name);
+	target_debug("PSCSI: Allocated pdv: %p for %s\n", pdv, name);
 	return &pdv->dev;
 }
 
@@ -356,8 +357,8 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	int ret;
 
 	if (scsi_device_get(sd)) {
-		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
-			sh->host_no, sd->channel, sd->id, sd->lun);
+		target_err("scsi_device_get() failed for %d:%d:%d:%llu\n", sh->host_no, sd->channel,
+			   sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return -EIO;
 	}
@@ -369,7 +370,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	bdev_file = bdev_file_open_by_path(dev->udev_path,
 				BLK_OPEN_WRITE | BLK_OPEN_READ, pdv, NULL);
 	if (IS_ERR(bdev_file)) {
-		pr_err("pSCSI: bdev_file_open_by_path() failed\n");
+		target_err("pSCSI: bdev_file_open_by_path() failed\n");
 		scsi_device_put(sd);
 		return PTR_ERR(bdev_file);
 	}
@@ -382,9 +383,9 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 		return ret;
 	}
 
-	pr_debug("CORE_PSCSI[%d] - Added TYPE_%s for %d:%d:%d:%llu\n",
-		phv->phv_host_id, sd->type == TYPE_DISK ? "DISK" : "ZBC",
-		sh->host_no, sd->channel, sd->id, sd->lun);
+	target_debug("CORE_PSCSI[%d] - Added TYPE_%s for %d:%d:%d:%llu\n", phv->phv_host_id,
+		     sd->type == TYPE_DISK ? "DISK" : "ZBC", sh->host_no, sd->channel, sd->id,
+		     sd->lun);
 	return 0;
 }
 
@@ -399,8 +400,8 @@ static int pscsi_create_type_nondisk(struct se_device *dev, struct scsi_device *
 	int ret;
 
 	if (scsi_device_get(sd)) {
-		pr_err("scsi_device_get() failed for %d:%d:%d:%llu\n",
-			sh->host_no, sd->channel, sd->id, sd->lun);
+		target_err("scsi_device_get() failed for %d:%d:%d:%llu\n", sh->host_no, sd->channel,
+			   sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return -EIO;
 	}
@@ -411,9 +412,8 @@ static int pscsi_create_type_nondisk(struct se_device *dev, struct scsi_device *
 		scsi_device_put(sd);
 		return ret;
 	}
-	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%llu\n",
-		phv->phv_host_id, scsi_device_type(sd->type), sh->host_no,
-		sd->channel, sd->id, sd->lun);
+	target_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%llu\n", phv->phv_host_id,
+		     scsi_device_type(sd->type), sh->host_no, sd->channel, sd->id, sd->lun);
 
 	return 0;
 }
@@ -431,8 +431,8 @@ static int pscsi_configure_device(struct se_device *dev)
 	if (!(pdv->pdv_flags & PDF_HAS_CHANNEL_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_TARGET_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_LUN_ID)) {
-		pr_err("Missing scsi_channel_id=, scsi_target_id= and"
-			" scsi_lun_id= parameters\n");
+		target_err("Missing scsi_channel_id=, scsi_target_id= and"
+			   " scsi_lun_id= parameters\n");
 		return -EINVAL;
 	}
 
@@ -442,8 +442,8 @@ static int pscsi_configure_device(struct se_device *dev)
 	 */
 	if (!sh) {
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-			pr_err("pSCSI: Unable to locate struct"
-				" Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
+			target_err("pSCSI: Unable to locate struct"
+				   " Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
 			return -ENODEV;
 		}
 		/*
@@ -451,8 +451,8 @@ static int pscsi_configure_device(struct se_device *dev)
 		 * reference, we enforce that udev_path has been set
 		 */
 		if (!(dev->dev_flags & DF_USING_UDEV_PATH)) {
-			pr_err("pSCSI: udev_path attribute has not"
-				" been set before ENABLE=1\n");
+			target_err("pSCSI: udev_path attribute has not"
+				   " been set before ENABLE=1\n");
 			return -EINVAL;
 		}
 		/*
@@ -462,8 +462,8 @@ static int pscsi_configure_device(struct se_device *dev)
 		 */
 		if (!(pdv->pdv_flags & PDF_HAS_VIRT_HOST_ID)) {
 			if (hba->dev_count) {
-				pr_err("pSCSI: Unable to set hba_mode"
-					" with active devices\n");
+				target_err("pSCSI: Unable to set hba_mode"
+					   " with active devices\n");
 				return -EEXIST;
 			}
 
@@ -476,16 +476,17 @@ static int pscsi_configure_device(struct se_device *dev)
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
 			if (!sh) {
-				pr_err("pSCSI: Unable to locate"
-					" pdv_host_id: %d\n", pdv->pdv_host_id);
+				target_err("pSCSI: Unable to locate"
+					   " pdv_host_id: %d\n",
+					   pdv->pdv_host_id);
 				return -EINVAL;
 			}
 			pdv->pdv_lld_host = sh;
 		}
 	} else {
 		if (phv->phv_mode == PHV_VIRTUAL_HOST_ID) {
-			pr_err("pSCSI: PHV_VIRTUAL_HOST_ID set while"
-				" struct Scsi_Host exists\n");
+			target_err("pSCSI: PHV_VIRTUAL_HOST_ID set while"
+				   " struct Scsi_Host exists\n");
 			return -EEXIST;
 		}
 	}
@@ -525,8 +526,8 @@ static int pscsi_configure_device(struct se_device *dev)
 	}
 	spin_unlock_irq(sh->host_lock);
 
-	pr_err("pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no,
-		pdv->pdv_channel_id,  pdv->pdv_target_id, pdv->pdv_lun_id);
+	target_err("pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no, pdv->pdv_channel_id,
+		   pdv->pdv_target_id, pdv->pdv_lun_id);
 
 	if (phv->phv_mode == PHV_VIRTUAL_HOST_ID)
 		scsi_host_put(sh);
@@ -648,7 +649,7 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 
 		buf = sg_virt(&cmd->t_data_sg[0]);
 		if (!buf) {
-			pr_err("Unable to get buf for scatterlist\n");
+			target_err("Unable to get buf for scatterlist\n");
 			goto after_mode_select;
 		}
 
@@ -687,7 +688,7 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			if (req_sense[0] == 0xf0 &&	/* valid, fixed format */
 			    req_sense[2] & 0xe0 &&	/* FM, EOM, or ILI */
 			    (req_sense[2] & 0xf) == 0) { /* key==NO_SENSE */
-				pr_debug("Tape FM/EOM/ILI status detected. Treat as normal read.\n");
+				target_debug("Tape FM/EOM/ILI status detected. Treat as normal read.\n");
 				cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
 			}
 		}
@@ -730,10 +731,10 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_scsi_host_id:
 			if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-				pr_err("PSCSI[%d]: Unable to accept"
-					" scsi_host_id while phv_mode =="
-					" PHV_LLD_SCSI_HOST_NO\n",
-					phv->phv_host_id);
+				target_err("PSCSI[%d]: Unable to accept"
+					   " scsi_host_id while phv_mode =="
+					   " PHV_LLD_SCSI_HOST_NO\n",
+					   phv->phv_host_id);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -741,8 +742,9 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_host_id = arg;
-			pr_debug("PSCSI[%d]: Referencing SCSI Host ID:"
-				" %d\n", phv->phv_host_id, pdv->pdv_host_id);
+			target_debug("PSCSI[%d]: Referencing SCSI Host ID:"
+				     " %d\n",
+				     phv->phv_host_id, pdv->pdv_host_id);
 			pdv->pdv_flags |= PDF_HAS_VIRT_HOST_ID;
 			break;
 		case Opt_scsi_channel_id:
@@ -750,9 +752,9 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_channel_id = arg;
-			pr_debug("PSCSI[%d]: Referencing SCSI Channel"
-				" ID: %d\n",  phv->phv_host_id,
-				pdv->pdv_channel_id);
+			target_debug("PSCSI[%d]: Referencing SCSI Channel"
+				     " ID: %d\n",
+				     phv->phv_host_id, pdv->pdv_channel_id);
 			pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
 			break;
 		case Opt_scsi_target_id:
@@ -760,9 +762,9 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_target_id = arg;
-			pr_debug("PSCSI[%d]: Referencing SCSI Target"
-				" ID: %d\n", phv->phv_host_id,
-				pdv->pdv_target_id);
+			target_debug("PSCSI[%d]: Referencing SCSI Target"
+				     " ID: %d\n",
+				     phv->phv_host_id, pdv->pdv_target_id);
 			pdv->pdv_flags |= PDF_HAS_TARGET_ID;
 			break;
 		case Opt_scsi_lun_id:
@@ -770,8 +772,9 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_device *dev,
 			if (ret)
 				goto out;
 			pdv->pdv_lun_id = arg;
-			pr_debug("PSCSI[%d]: Referencing SCSI LUN ID:"
-				" %d\n", phv->phv_host_id, pdv->pdv_lun_id);
+			target_debug("PSCSI[%d]: Referencing SCSI LUN ID:"
+				     " %d\n",
+				     phv->phv_host_id, pdv->pdv_lun_id);
 			pdv->pdv_flags |= PDF_HAS_LUN_ID;
 			break;
 		default:
@@ -835,15 +838,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	BUG_ON(!cmd->data_length);
 
-	pr_debug("PSCSI: nr_pages: %d\n", nr_pages);
+	target_debug("PSCSI: nr_pages: %d\n", nr_pages);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
 
-		pr_debug("PSCSI: i: %d page: %p len: %d off: %d\n", i,
-			page, len, off);
+		target_debug("PSCSI: i: %d page: %p len: %d off: %d\n", i, page, len, off);
 
 		/*
 		 * We only have one page of data in each sg element,
@@ -866,27 +868,28 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					 rw ? REQ_OP_WRITE : REQ_OP_READ);
 				bio->bi_end_io = pscsi_bi_endio;
 
-				pr_debug("PSCSI: Allocated bio: %p,"
-					" dir: %s nr_vecs: %d\n", bio,
-					(rw) ? "rw" : "r", nr_vecs);
+				target_debug("PSCSI: Allocated bio: %p,"
+					     " dir: %s nr_vecs: %d\n",
+					     bio, (rw) ? "rw" : "r", nr_vecs);
 			}
 
-			pr_debug("PSCSI: Calling bio_add_pc_page() i: %d"
-				" bio: %p page: %p len: %d off: %d\n", i, bio,
-				page, len, off);
+			target_debug("PSCSI: Calling bio_add_pc_page() i: %d"
+				     " bio: %p page: %p len: %d off: %d\n",
+				     i, bio, page, len, off);
 
 			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
 					bio, page, bytes, off);
-			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
-				bio_segments(bio), nr_vecs);
+			target_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n", bio_segments(bio),
+				     nr_vecs);
 			if (rc != bytes) {
-				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
-					" %d i: %d bio: %p, allocating another"
-					" bio\n", bio->bi_vcnt, i, bio);
+				target_debug("PSCSI: Reached bio->bi_vcnt max:"
+					     " %d i: %d bio: %p, allocating another"
+					     " bio\n",
+					     bio->bi_vcnt, i, bio);
 
 				rc = blk_rq_append_bio(req, bio);
 				if (rc) {
-					pr_err("pSCSI: failed to append bio\n");
+					target_err("pSCSI: failed to append bio\n");
 					goto fail;
 				}
 
@@ -900,7 +903,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (bio) {
 		rc = blk_rq_append_bio(req, bio);
 		if (rc) {
-			pr_err("pSCSI: failed to append bio\n");
+			target_err("pSCSI: failed to append bio\n");
 			goto fail;
 		}
 	}
@@ -1012,8 +1015,9 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 	u8 *cdb = cmd->priv;
 
 	if (scsi_status != SAM_STAT_GOOD) {
-		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
-			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd->result);
+		target_debug("PSCSI Status Byte exception at cmd: %p CDB:"
+			     " 0x%02x Result: 0x%08x\n",
+			     cmd, cdb[0], scmd->result);
 	}
 
 	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer, valid_data);
@@ -1023,8 +1027,9 @@ static enum rq_end_io_ret pscsi_req_done(struct request *req,
 		target_complete_cmd_with_length(cmd, scsi_status, valid_data);
 		break;
 	default:
-		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
-			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd->result);
+		target_debug("PSCSI Host Byte exception at cmd: %p CDB:"
+			     " 0x%02x Result: 0x%08x\n",
+			     cmd, cdb[0], scmd->result);
 		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		break;
 	}
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6f67cc09c2b5..7d83a4ed93da 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -42,9 +42,9 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = rd_host;
 
-	pr_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
-		" Generic Target Core Stack %s\n", hba->hba_id,
-		RD_HBA_VERSION, TARGET_CORE_VERSION);
+	target_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
+		     " Generic Target Core Stack %s\n",
+		     hba->hba_id, RD_HBA_VERSION, TARGET_CORE_VERSION);
 
 	return 0;
 }
@@ -53,8 +53,9 @@ static void rd_detach_hba(struct se_hba *hba)
 {
 	struct rd_host *rd_host = hba->hba_ptr;
 
-	pr_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
-		" Generic Target Core\n", hba->hba_id, rd_host->rd_host_id);
+	target_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
+		     " Generic Target Core\n",
+		     hba->hba_id, rd_host->rd_host_id);
 
 	kfree(rd_host);
 	hba->hba_ptr = NULL;
@@ -95,10 +96,10 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_table_array,
 					  rd_dev->sg_table_count);
 
-	pr_debug("CORE_RD[%u] - Released device space for Ramdisk"
-		" Device ID: %u, pages %u in %u tables total bytes %lu\n",
-		rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
-		rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
+	target_debug("CORE_RD[%u] - Released device space for Ramdisk"
+		     " Device ID: %u, pages %u in %u tables total bytes %lu\n",
+		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
+		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
 	rd_dev->sg_table_array = NULL;
 	rd_dev->sg_table_count = 0;
@@ -152,8 +153,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 		for (j = 0; j < sg_per_table; j++) {
 			pg = alloc_pages(GFP_KERNEL, 0);
 			if (!pg) {
-				pr_err("Unable to allocate scatterlist"
-					" pages for struct rd_dev_sg_table\n");
+				target_err("Unable to allocate scatterlist"
+					   " pages for struct rd_dev_sg_table\n");
 				return -ENOMEM;
 			}
 			sg_assign_page(&sg[j], pg);
@@ -180,8 +181,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	int rc;
 
 	if (rd_dev->rd_page_count <= 0) {
-		pr_err("Illegal page count: %u for Ramdisk device\n",
-		       rd_dev->rd_page_count);
+		target_err("Illegal page count: %u for Ramdisk device\n", rd_dev->rd_page_count);
 		return -EINVAL;
 	}
 
@@ -203,10 +203,10 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rc)
 		return rc;
 
-	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
-		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-		 rd_dev->rd_dev_id, rd_dev->rd_page_count,
-		 rd_dev->sg_table_count);
+	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
+		     " %u pages in %u tables\n",
+		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
+		     rd_dev->sg_table_count);
 
 	return 0;
 }
@@ -221,10 +221,10 @@ static void rd_release_prot_space(struct rd_dev *rd_dev)
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_prot_array,
 					  rd_dev->sg_prot_count);
 
-	pr_debug("CORE_RD[%u] - Released protection space for Ramdisk"
-		 " Device ID: %u, pages %u in %u tables total bytes %lu\n",
-		 rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
-		 rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
+	target_debug("CORE_RD[%u] - Released protection space for Ramdisk"
+		     " Device ID: %u, pages %u in %u tables total bytes %lu\n",
+		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
+		     rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
 	rd_dev->sg_prot_array = NULL;
 	rd_dev->sg_prot_count = 0;
@@ -260,9 +260,10 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	if (rc)
 		return rc;
 
-	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
-		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-		 rd_dev->rd_dev_id, total_sg_needed, rd_dev->sg_prot_count);
+	target_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
+		     " %u pages in %u tables\n",
+		     rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, total_sg_needed,
+		     rd_dev->sg_prot_count);
 
 	return 0;
 }
@@ -288,7 +289,7 @@ static int rd_configure_device(struct se_device *dev)
 	int ret;
 
 	if (!(rd_dev->rd_flags & RDF_HAS_PAGE_COUNT)) {
-		pr_debug("Missing rd_pages= parameter\n");
+		target_debug("Missing rd_pages= parameter\n");
 		return -EINVAL;
 	}
 
@@ -303,11 +304,10 @@ static int rd_configure_device(struct se_device *dev)
 
 	rd_dev->rd_dev_id = rd_host->rd_host_dev_id_count++;
 
-	pr_debug("CORE_RD[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of"
-		" %u pages in %u tables, %lu total bytes\n",
-		rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
-		rd_dev->sg_table_count,
-		(unsigned long)(rd_dev->rd_page_count * PAGE_SIZE));
+	target_debug("CORE_RD[%u] - Added TCM MEMCPY Ramdisk Device ID: %u of"
+		     " %u pages in %u tables, %lu total bytes\n",
+		     rd_host->rd_host_id, rd_dev->rd_dev_id, rd_dev->rd_page_count,
+		     rd_dev->sg_table_count, (unsigned long)(rd_dev->rd_page_count * PAGE_SIZE));
 
 	return 0;
 
@@ -350,8 +350,7 @@ static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
 			return sg_table;
 	}
 
-	pr_err("Unable to locate struct rd_dev_sg_table for page: %u\n",
-			page);
+	target_err("Unable to locate struct rd_dev_sg_table for page: %u\n", page);
 
 	return NULL;
 }
@@ -370,8 +369,7 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
 			return sg_table;
 	}
 
-	pr_err("Unable to locate struct prot rd_dev_sg_table for page: %u\n",
-			page);
+	target_err("Unable to locate struct prot rd_dev_sg_table for page: %u\n", page);
 
 	return NULL;
 }
@@ -445,10 +443,9 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	rd_sg = &table->sg_table[rd_page - table->page_start_offset];
 
-	pr_debug("RD[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n",
-			dev->rd_dev_id,
-			data_direction == DMA_FROM_DEVICE ? "Read" : "Write",
-			cmd->t_task_lba, rd_size, rd_page, rd_offset);
+	target_debug("RD[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n", dev->rd_dev_id,
+		     data_direction == DMA_FROM_DEVICE ? "Read" : "Write", cmd->t_task_lba, rd_size,
+		     rd_page, rd_offset);
 
 	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_TO_DEVICE) {
@@ -467,16 +464,16 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 		sg_miter_next(&m);
 		if (!(u32)m.length) {
-			pr_debug("RD[%u]: invalid sgl %p len %zu\n",
-				 dev->rd_dev_id, m.addr, m.length);
+			target_debug("RD[%u]: invalid sgl %p len %zu\n", dev->rd_dev_id, m.addr,
+				     m.length);
 			sg_miter_stop(&m);
 			return TCM_INCORRECT_AMOUNT_OF_DATA;
 		}
 		len = min((u32)m.length, src_len);
 		if (len > rd_size) {
-			pr_debug("RD[%u]: size underrun page %d offset %d "
-				 "size %d\n", dev->rd_dev_id,
-				 rd_page, rd_offset, rd_size);
+			target_debug("RD[%u]: size underrun page %d offset %d "
+				     "size %d\n",
+				     dev->rd_dev_id, rd_page, rd_offset, rd_size);
 			len = rd_size;
 		}
 		m.consumed = len;
@@ -563,8 +560,9 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 		case Opt_rd_pages:
 			match_int(args, &arg);
 			rd_dev->rd_page_count = arg;
-			pr_debug("RAMDISK: Referencing Page"
-				" Count: %u\n", rd_dev->rd_page_count);
+			target_debug("RAMDISK: Referencing Page"
+				     " Count: %u\n",
+				     rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
 		case Opt_rd_nullio:
@@ -572,7 +570,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			if (arg != 1)
 				break;
 
-			pr_debug("RAMDISK: Setting NULLIO flag: %d\n", arg);
+			target_debug("RAMDISK: Setting NULLIO flag: %d\n", arg);
 			rd_dev->rd_flags |= RDF_NULLIO;
 			break;
 		case Opt_rd_dummy:
@@ -580,7 +578,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			if (arg != 1)
 				break;
 
-			pr_debug("RAMDISK: Setting DUMMY flag: %d\n", arg);
+			target_debug("RAMDISK: Setting DUMMY flag: %d\n", arg);
 			rd_dev->rd_flags |= RDF_DUMMY;
 			break;
 		default:
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6a02561cc20c..8c4bb62e96fc 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -280,14 +280,14 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 	sense_reason_t ret;
 
 	if ((flags & 0x04) || (flags & 0x02)) {
-		pr_err("WRITE_SAME PBDATA and LBDATA"
-			" bits not supported for Block Discard"
-			" Emulation\n");
+		target_err("WRITE_SAME PBDATA and LBDATA"
+			   " bits not supported for Block Discard"
+			   " Emulation\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
-		pr_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
-			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
+		target_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n", sectors,
+			    cmd->se_dev->dev_attrib.max_write_same_len);
 		return TCM_INVALID_CDB_FIELD;
 	}
 	/*
@@ -295,19 +295,19 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 	 */
 	if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
 	    ((cmd->t_task_lba + sectors) > end_lba)) {
-		pr_err("WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
-		       (unsigned long long)end_lba, cmd->t_task_lba, sectors);
+		target_err("WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
+			   (unsigned long long)end_lba, cmd->t_task_lba, sectors);
 		return TCM_ADDRESS_OUT_OF_RANGE;
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
 	if (flags & 0x10) {
-		pr_warn("WRITE SAME with ANCHOR not supported\n");
+		target_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
 	if (flags & 0x01) {
-		pr_warn("WRITE SAME with NDOB not supported\n");
+		target_warn("WRITE SAME with NDOB not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -320,8 +320,8 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpws) {
-			pr_err("Got WRITE_SAME w/ UNMAP=1, but backend device"
-			       " has emulate_tpws disabled\n");
+			target_err("Got WRITE_SAME w/ UNMAP=1, but backend device"
+				   " has emulate_tpws disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		cmd->execute_cmd = sbc_execute_write_same_unmap;
@@ -395,7 +395,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 
 	rc = sg_copy_to_buffer(cmp_sgl, cmp_nents, buf, cmp_len);
 	if (!rc) {
-		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
+		target_err("sg_copy_to_buffer() failed for compare_and_write\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
@@ -414,8 +414,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 			for (i = 0; i < len && addr[i] == buf[offset + i]; i++)
 				;
 			*miscmp_off = offset + i;
-			pr_warn("Detected MISCOMPARE at offset %u\n",
-				*miscmp_off);
+			target_warn("Detected MISCOMPARE at offset %u\n", *miscmp_off);
 			ret = TCM_MISCOMPARE_VERIFY;
 		}
 		kunmap_atomic(addr);
@@ -427,7 +426,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 		if (!cmp_len)
 			break;
 	}
-	pr_debug("COMPARE AND WRITE read data matches compare data\n");
+	target_debug("COMPARE AND WRITE read data matches compare data\n");
 out:
 	kfree(buf);
 	return ret;
@@ -473,8 +472,9 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * been failed with a non-zero SCSI status.
 	 */
 	if (cmd->scsi_status) {
-		pr_debug("compare_and_write_callback: non zero scsi_status:"
-			" 0x%02x\n", cmd->scsi_status);
+		target_debug("compare_and_write_callback: non zero scsi_status:"
+			     " 0x%02x\n",
+			     cmd->scsi_status);
 		*post_ret = 1;
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -500,7 +500,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 
 	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
-		pr_err("Unable to allocate compare_and_write sg\n");
+		target_err("Unable to allocate compare_and_write sg\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
@@ -629,7 +629,7 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
-			pr_err("Unsupported protect field %d\n", protect);
+			target_err("Unsupported protect field %d\n", protect);
 			return -EINVAL;
 		}
 	} else {
@@ -655,7 +655,7 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
-			pr_err("Unsupported protect field %d\n", protect);
+			target_err("Unsupported protect field %d\n", protect);
 			return -EINVAL;
 		}
 	}
@@ -674,8 +674,8 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
 		if (unlikely(protect &&
 		    !dev->dev_attrib.pi_prot_type && !cmd->se_sess->sess_prot_type)) {
-			pr_err("CDB contains protect bit, but device + fabric does"
-			       " not advertise PROTECT=1 feature bit\n");
+			target_err("CDB contains protect bit, but device + fabric does"
+				   " not advertise PROTECT=1 feature bit\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (cmd->prot_pto)
@@ -713,8 +713,9 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 			return TCM_NO_SENSE;
 		fallthrough;
 	default:
-		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-		       "PROTECT: 0x%02x\n", cmd->t_task_cdb[0], protect);
+		target_err("Unable to determine pi_prot_type for CDB: 0x%02x "
+			   "PROTECT: 0x%02x\n",
+			   cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -733,10 +734,10 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (protect)
 		cmd->data_length = sectors * dev->dev_attrib.block_size;
 
-	pr_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
-		 "prot_op=%d prot_checks=%d\n",
-		 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length,
-		 cmd->prot_op, cmd->prot_checks);
+	target_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
+		     "prot_op=%d prot_checks=%d\n",
+		     __func__, cmd->prot_type, cmd->data_length, cmd->prot_length, cmd->prot_op,
+		     cmd->prot_checks);
 
 	return TCM_NO_SENSE;
 }
@@ -747,16 +748,17 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	if (cdb[1] & 0x10) {
 		/* see explanation in spc_emulate_modesense */
 		if (!target_check_fua(dev)) {
-			pr_err("Got CDB: 0x%02x with DPO bit set, but device"
-			       " does not advertise support for DPO\n", cdb[0]);
+			target_err("Got CDB: 0x%02x with DPO bit set, but device"
+				   " does not advertise support for DPO\n",
+				   cdb[0]);
 			return -EINVAL;
 		}
 	}
 	if (cdb[1] & 0x8) {
 		if (!target_check_fua(dev)) {
-			pr_err("Got CDB: 0x%02x with FUA bit set, but device"
-			       " does not advertise support for FUA write\n",
-			       cdb[0]);
+			target_err("Got CDB: 0x%02x with FUA bit set, but device"
+				   " does not advertise support for FUA write\n",
+				   cdb[0]);
 			return -EINVAL;
 		}
 		cmd->se_cmd_flags |= SCF_FUA;
@@ -881,8 +883,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
 			if (!sectors) {
-				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
-				       " supported\n");
+				target_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
+					   " supported\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 
@@ -894,18 +896,19 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 				return ret;
 			break;
 		default:
-			pr_err("VARIABLE_LENGTH_CMD service action"
-				" 0x%04x not supported\n", service_action);
+			target_err("VARIABLE_LENGTH_CMD service action"
+				   " 0x%04x not supported\n",
+				   service_action);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		break;
 	}
 	case COMPARE_AND_WRITE:
 		if (!dev->dev_attrib.emulate_caw) {
-			pr_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
-					   dev->se_hba->backend->ops->name,
-					   config_item_name(&dev->dev_group.cg_item),
-					   dev->t10_wwn.unit_serial);
+			target_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
+					       dev->se_hba->backend->ops->name,
+					       config_item_name(&dev->dev_group.cg_item),
+					       dev->t10_wwn.unit_serial);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		sectors = cdb[13];
@@ -913,8 +916,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		 * Currently enforce COMPARE_AND_WRITE for a single sector
 		 */
 		if (sectors > 1) {
-			pr_err("COMPARE_AND_WRITE contains NoLB: %u greater"
-			       " than 1\n", sectors);
+			target_err("COMPARE_AND_WRITE contains NoLB: %u greater"
+				   " than 1\n",
+				   sectors);
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (sbc_check_dpofua(dev, cmd, cdb))
@@ -944,8 +948,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			cmd->execute_cmd = target_emulate_report_referrals;
 			break;
 		default:
-			pr_err("Unsupported SA: 0x%02x\n",
-				cmd->t_task_cdb[1] & 0x1f);
+			target_err("Unsupported SA: 0x%02x\n", cmd->t_task_cdb[1] & 0x1f);
 			return TCM_INVALID_CDB_FIELD;
 		}
 		size = get_unaligned_be32(&cdb[10]);
@@ -971,8 +974,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (!dev->dev_attrib.emulate_tpu) {
-			pr_err("Got UNMAP, but backend device has"
-			       " emulate_tpu disabled\n");
+			target_err("Got UNMAP, but backend device has"
+				   " emulate_tpu disabled\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		size = get_unaligned_be16(&cdb[7]);
@@ -981,7 +984,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 	case WRITE_SAME_16:
 		sectors = transport_get_sectors_16(cdb);
 		if (!sectors) {
-			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+			target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -995,7 +998,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 	case WRITE_SAME:
 		sectors = transport_get_sectors_10(cdb);
 		if (!sectors) {
-			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+			target_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -1054,9 +1057,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		end_lba = dev->transport->get_blocks(dev) + 1;
 		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
 		    ((cmd->t_task_lba + sectors) > end_lba)) {
-			pr_err("cmd exceeds last lba %llu "
-				"(lba %llu, sectors %u)\n",
-				end_lba, cmd->t_task_lba, sectors);
+			target_err("cmd exceeds last lba %llu "
+				   "(lba %llu, sectors %u)\n",
+				   end_lba, cmd->t_task_lba, sectors);
 			return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 
@@ -1096,8 +1099,7 @@ sbc_execute_unmap(struct se_cmd *cmd)
 	}
 
 	if (cmd->data_length < 8) {
-		pr_warn("UNMAP parameter list length %u too small\n",
-			cmd->data_length);
+		target_warn("UNMAP parameter list length %u too small\n", cmd->data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -1110,8 +1112,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 
 	size = cmd->data_length - 8;
 	if (bd_dl > size)
-		pr_warn("UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
-			cmd->data_length, bd_dl);
+		target_warn("UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
+			    cmd->data_length, bd_dl);
 	else
 		size = bd_dl;
 
@@ -1122,14 +1124,15 @@ sbc_execute_unmap(struct se_cmd *cmd)
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	ptr = &buf[8];
-	pr_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u"
-		" ptr: %p\n", dev->transport->name, dl, bd_dl, size, ptr);
+	target_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u"
+		     " ptr: %p\n",
+		     dev->transport->name, dl, bd_dl, size, ptr);
 
 	while (size >= 16) {
 		lba = get_unaligned_be64(&ptr[0]);
 		range = get_unaligned_be32(&ptr[8]);
-		pr_debug("UNMAP: Using lba: %llu and range: %u\n",
-				 (unsigned long long)lba, range);
+		target_debug("UNMAP: Using lba: %llu and range: %u\n", (unsigned long long)lba,
+			     range);
 
 		if (range > dev->dev_attrib.max_unmap_lba_count) {
 			ret = TCM_INVALID_PARAMETER_LIST;
@@ -1211,12 +1214,11 @@ sbc_dif_generate(struct se_cmd *cmd)
 				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
 			sdt->app_tag = 0;
 
-			pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (cmd->data_direction == DMA_TO_DEVICE) ?
-				 "WRITE" : "READ", (unsigned long long)sector,
-				 sdt->guard_tag, sdt->app_tag,
-				 be32_to_cpu(sdt->ref_tag));
+			target_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
+				     " app_tag: 0x%04x ref_tag: %u\n",
+				     (cmd->data_direction == DMA_TO_DEVICE) ? "WRITE" : "READ",
+				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
+				     be32_to_cpu(sdt->ref_tag));
 
 			sector++;
 		}
@@ -1238,9 +1240,10 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	csum = cpu_to_be16(crc);
 
 	if (sdt->guard_tag != csum) {
-		pr_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x"
-			" csum 0x%04x\n", (unsigned long long)sector,
-			be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
+		target_err("DIFv1 checksum failed on sector %llu guard tag 0x%04x"
+			   " csum 0x%04x\n",
+			   (unsigned long long)sector, be16_to_cpu(sdt->guard_tag),
+			   be16_to_cpu(csum));
 		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 	}
 
@@ -1250,17 +1253,18 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 
 	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
-		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
-		       " sector MSB: 0x%08x\n", (unsigned long long)sector,
-		       be32_to_cpu(sdt->ref_tag), (u32)(sector & 0xffffffff));
+		target_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
+			   " sector MSB: 0x%08x\n",
+			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag),
+			   (u32)(sector & 0xffffffff));
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
 	if (cmd->prot_type == TARGET_DIF_TYPE2_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-		pr_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
-		       " ei_lba: 0x%08x\n", (unsigned long long)sector,
-			be32_to_cpu(sdt->ref_tag), ei_lba);
+		target_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
+			   " ei_lba: 0x%08x\n",
+			   (unsigned long long)sector, be32_to_cpu(sdt->ref_tag), ei_lba);
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
@@ -1349,10 +1353,10 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			sdt = paddr + i;
 
-			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (unsigned long long)sector, sdt->guard_tag,
-				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+			target_debug("DIF READ sector: %llu guard_tag: 0x%04x"
+				     " app_tag: 0x%04x ref_tag: %u\n",
+				     (unsigned long long)sector, sdt->guard_tag, sdt->app_tag,
+				     be32_to_cpu(sdt->ref_tag));
 
 			if (sdt->app_tag == T10_PI_APP_ESCAPE) {
 				dsg_off += block_size;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 50290abc07bc..7c5c117389cc 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -62,8 +62,9 @@ spc_find_scsi_transport_vd(int proto_id)
 	case SCSI_PROTOCOL_SRP:
 		return SCSI_VERSION_DESCRIPTOR_SRP;
 	default:
-		pr_warn("Cannot find VERSION DESCRIPTOR value for unknown SCSI"
-			" transport PROTOCOL IDENTIFIER %#x\n", proto_id);
+		target_warn("Cannot find VERSION DESCRIPTOR value for unknown SCSI"
+			    " transport PROTOCOL IDENTIFIER %#x\n",
+			    proto_id);
 		return 0;
 	}
 }
@@ -742,7 +743,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
 	if (!buf) {
-		pr_err("Unable to allocate response buffer for INQUIRY\n");
+		target_err("Unable to allocate response buffer for INQUIRY\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -750,8 +751,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	if (!(cdb[1] & 0x1)) {
 		if (cdb[2]) {
-			pr_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n",
-			       cdb[2]);
+			target_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n", cdb[2]);
 			ret = TCM_INVALID_CDB_FIELD;
 			goto out;
 		}
@@ -770,7 +770,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 	}
 
-	pr_debug("Unknown VPD Code: 0x%02x\n", cdb[2]);
+	target_debug("Unknown VPD Code: 0x%02x\n", cdb[2]);
 	ret = TCM_INVALID_CDB_FIELD;
 
 out:
@@ -1085,7 +1085,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 
 	if (page == 0x3f) {
 		if (subpage != 0x00 && subpage != 0xff) {
-			pr_warn("MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
+			target_warn("MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -1119,8 +1119,8 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	 *  - obsolete page 03h "format parameters" (checked by Solaris)
 	 */
 	if (page != 0x03)
-		pr_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
-		       page, subpage);
+		target_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n", page,
+			   subpage);
 
 	return TCM_UNKNOWN_MODE_PAGE;
 
@@ -1212,8 +1212,8 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memset(buf, 0, SE_SENSE_BUF);
 
 	if (cdb[1] & 0x01) {
-		pr_err("REQUEST_SENSE description emulation not"
-			" supported\n");
+		target_err("REQUEST_SENSE description emulation not"
+			   " supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2125,11 +2125,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 	*opcode = NULL;
 
 	if (opts > 3) {
-		pr_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES"
-			" with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
-			cmd->se_tfo->fabric_name, opts,
-			cmd->se_lun->unpacked_lun,
-			sess->se_node_acl->initiatorname);
+		target_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES"
+			     " with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
+			     cmd->se_tfo->fabric_name, opts, cmd->se_lun->unpacked_lun,
+			     sess->se_node_acl->initiatorname);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4718db628222..aa1c099fa92e 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -33,7 +33,7 @@ int core_tmr_alloc_req(
 
 	tmr = kzalloc(sizeof(struct se_tmr_req), gfp_flags);
 	if (!tmr) {
-		pr_err("Unable to allocate struct se_tmr_req\n");
+		target_err("Unable to allocate struct se_tmr_req\n");
 		return -ENOMEM;
 	}
 
@@ -87,8 +87,9 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 	 */
 	spin_lock(&se_cmd->t_state_lock);
 	if (se_cmd->transport_state & (CMD_T_COMPLETE | CMD_T_FABRIC_STOP)) {
-		pr_debug("Attempted to abort io tag: %llu already complete or"
-			" fabric stop, skipping\n", se_cmd->tag);
+		target_debug("Attempted to abort io tag: %llu already complete or"
+			     " fabric stop, skipping\n",
+			     se_cmd->tag);
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
@@ -134,8 +135,8 @@ void core_tmr_abort_task(
 			if (tmr->ref_task_tag != ref_tag)
 				continue;
 
-			pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
-			       se_cmd->se_tfo->fabric_name, ref_tag);
+			target_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
+				   se_cmd->se_tfo->fabric_name, ref_tag);
 
 			spin_lock(&se_sess->sess_cmd_lock);
 			rc = __target_check_io_state(se_cmd, se_sess, 0);
@@ -154,8 +155,8 @@ void core_tmr_abort_task(
 			list_del_init(&se_cmd->state_list);
 			target_put_cmd_and_wait(se_cmd);
 
-			pr_err("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
-			       ref_tag);
+			target_err("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
+				   ref_tag);
 			tmr->response = TMR_FUNCTION_COMPLETE;
 			atomic_long_inc(&dev->aborts_complete);
 			return;
@@ -166,8 +167,8 @@ void core_tmr_abort_task(
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
 
-	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
-			tmr->ref_task_tag);
+	target_err("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
+		   tmr->ref_task_tag);
 	tmr->response = TMR_TASK_DOES_NOT_EXIST;
 	atomic_long_inc(&dev->aborts_no_task);
 }
@@ -194,7 +195,7 @@ static void core_tmr_drain_tmr_list(
 
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
-			pr_err("Unable to locate struct se_cmd for TMR\n");
+			target_err("Unable to locate struct se_cmd for TMR\n");
 			continue;
 		}
 
@@ -222,7 +223,7 @@ static void core_tmr_drain_tmr_list(
 		spin_unlock(&sess->sess_cmd_lock);
 
 		if (!rc) {
-			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
+			target_err("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
 			continue;
 		}
 
@@ -235,10 +236,10 @@ static void core_tmr_drain_tmr_list(
 		list_del_init(&tmr_p->tmr_list);
 		cmd = tmr_p->task_cmd;
 
-		pr_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
-			" Response: 0x%02x, t_state: %d\n",
-			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
-			tmr_p->function, tmr_p->response, cmd->t_state);
+		target_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
+			     " Response: 0x%02x, t_state: %d\n",
+			     (preempt_and_abort_list) ? "Preempt" : "", tmr_p, tmr_p->function,
+			     tmr_p->response, cmd->t_state);
 
 		target_put_cmd_and_wait(cmd);
 	}
@@ -343,9 +344,8 @@ static void core_tmr_drain_state_list(
 		list_del_init(&cmd->state_list);
 
 		target_show_cmd("LUN_RESET: ", cmd);
-		pr_debug("LUN_RESET: ITT[0x%08llx] - %s pr_res_key: 0x%016Lx\n",
-			 cmd->tag, (preempt_and_abort_list) ? "preempt" : "",
-			 cmd->pr_res_key);
+		target_debug("LUN_RESET: ITT[0x%08llx] - %s pr_res_key: 0x%016Lx\n", cmd->tag,
+			     (preempt_and_abort_list) ? "preempt" : "", cmd->pr_res_key);
 
 		target_put_cmd_and_wait(cmd);
 	}
@@ -382,10 +382,9 @@ int core_tmr_lun_reset(
 		tmr_nacl = tmr_sess->se_node_acl;
 		tmr_tpg = tmr_sess->se_tpg;
 		if (tmr_nacl && tmr_tpg) {
-			pr_debug("LUN_RESET: TMR caller fabric: %s"
-				" initiator port %s\n",
-				tmr_tpg->se_tpg_tfo->fabric_name,
-				tmr_nacl->initiatorname);
+			target_debug("LUN_RESET: TMR caller fabric: %s"
+				     " initiator port %s\n",
+				     tmr_tpg->se_tpg_tfo->fabric_name, tmr_nacl->initiatorname);
 		}
 	}
 
@@ -398,9 +397,8 @@ int core_tmr_lun_reset(
 	 */
 	mutex_lock(&dev->lun_reset_mutex);
 
-	pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
-		(preempt_and_abort_list) ? "Preempt" : "TMR",
-		dev->transport->name, tas);
+	target_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
+		     (preempt_and_abort_list) ? "Preempt" : "TMR", dev->transport->name, tas);
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
@@ -417,14 +415,13 @@ int core_tmr_lun_reset(
 		dev->reservation_holder = NULL;
 		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS;
 		spin_unlock(&dev->dev_reservation_lock);
-		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
+		target_debug("LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
 	atomic_long_inc(&dev->num_resets);
 
-	pr_debug("LUN_RESET: %s for [%s] Complete\n",
-			(preempt_and_abort_list) ? "Preempt" : "TMR",
-			dev->transport->name);
+	target_debug("LUN_RESET: %s for [%s] Complete\n",
+		     (preempt_and_abort_list) ? "Preempt" : "TMR", dev->transport->name);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0e429e5ef31..90d59ac5e4aa 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -134,11 +134,10 @@ void core_tpg_add_node_to_devs(
 				lun_access_ro = false;
 		}
 
-		pr_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s"
-			" access for LUN in Demo Mode\n",
-			tpg->se_tpg_tfo->fabric_name,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-			lun_access_ro ? "READ-ONLY" : "READ-WRITE");
+		target_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s"
+			     " access for LUN in Demo Mode\n",
+			     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			     lun->unpacked_lun, lun_access_ro ? "READ-ONLY" : "READ-WRITE");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 						 lun_access_ro, acl, tpg);
@@ -160,9 +159,9 @@ target_set_nacl_queue_depth(struct se_portal_group *tpg,
 	acl->queue_depth = queue_depth;
 
 	if (!acl->queue_depth) {
-		pr_warn("Queue depth for %s Initiator Node: %s is 0,"
-			"defaulting to 1.\n", tpg->se_tpg_tfo->fabric_name,
-			acl->initiatorname);
+		target_warn("Queue depth for %s Initiator Node: %s is 0,"
+			    "defaulting to 1.\n",
+			    tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 		acl->queue_depth = 1;
 	}
 }
@@ -210,14 +209,11 @@ static void target_add_node_acl(struct se_node_acl *acl)
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	mutex_unlock(&tpg->acl_node_mutex);
 
-	pr_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n",
-		tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg),
-		acl->dynamic_node_acl ? "DYNAMIC" : "",
-		acl->queue_depth,
-		tpg->se_tpg_tfo->fabric_name,
-		acl->initiatorname);
+	target_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s"
+		     " Initiator Node: %s\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     acl->dynamic_node_acl ? "DYNAMIC" : "", acl->queue_depth,
+		     tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 }
 
 bool target_tpg_has_node_acl(struct se_portal_group *tpg,
@@ -297,17 +293,19 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	if (acl) {
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
-			pr_debug("%s_TPG[%u] - Replacing dynamic ACL"
-				" for %s\n", tpg->se_tpg_tfo->fabric_name,
-				tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
+			target_debug("%s_TPG[%u] - Replacing dynamic ACL"
+				     " for %s\n",
+				     tpg->se_tpg_tfo->fabric_name,
+				     tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
 			mutex_unlock(&tpg->acl_node_mutex);
 			return acl;
 		}
 
-		pr_err("ACL entry for %s Initiator"
-			" Node %s already exists for TPG %u, ignoring"
-			" request.\n",  tpg->se_tpg_tfo->fabric_name,
-			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
+		target_err("ACL entry for %s Initiator"
+			   " Node %s already exists for TPG %u, ignoring"
+			   " request.\n",
+			   tpg->se_tpg_tfo->fabric_name, initiatorname,
+			   tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		mutex_unlock(&tpg->acl_node_mutex);
 		return ERR_PTR(-EEXIST);
 	}
@@ -364,10 +362,10 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	core_tpg_wait_for_nacl_pr_ref(acl);
 	core_free_device_list_for_node(acl, tpg);
 
-	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
-		tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
+	target_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
+		     " Initiator Node: %s\n",
+		     tpg->se_tpg_tfo->fabric_name, tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		     acl->queue_depth, tpg->se_tpg_tfo->fabric_name, acl->initiatorname);
 
 	kfree(acl);
 }
@@ -401,10 +399,10 @@ int core_tpg_set_initiator_node_queue_depth(
 	 */
 	target_shutdown_sessions(acl);
 
-	pr_debug("Successfully changed queue depth to: %d for Initiator"
-		" Node: %s on %s Target Portal Group: %u\n", acl->queue_depth,
-		acl->initiatorname, tpg->se_tpg_tfo->fabric_name,
-		tpg->se_tpg_tfo->tpg_get_tag(tpg));
+	target_debug("Successfully changed queue depth to: %d for Initiator"
+		     " Node: %s on %s Target Portal Group: %u\n",
+		     acl->queue_depth, acl->initiatorname, tpg->se_tpg_tfo->fabric_name,
+		     tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
 	return 0;
 }
@@ -448,10 +446,9 @@ static int target_tpg_register_rtpi(struct se_portal_group *se_tpg)
 	if (se_tpg->rtpi_manual) {
 		ret = xa_insert(&tpg_xa, se_tpg->tpg_rtpi, se_tpg, GFP_KERNEL);
 		if (ret) {
-			pr_info("%s_TPG[%hu] - Can not set RTPI %#x, it is already busy",
-				se_tpg->se_tpg_tfo->fabric_name,
-				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
-				se_tpg->tpg_rtpi);
+			target_info("%s_TPG[%hu] - Can not set RTPI %#x, it is already busy",
+				    se_tpg->se_tpg_tfo->fabric_name,
+				    se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg), se_tpg->tpg_rtpi);
 			return -EINVAL;
 		}
 	} else {
@@ -526,7 +523,7 @@ int core_tpg_register(
 		se_tpg->se_tpg_tfo = se_wwn->wwn_tf->tf_ops;
 
 	if (!se_tpg->se_tpg_tfo) {
-		pr_err("Unable to locate se_tpg->se_tpg_tfo pointer\n");
+		target_err("Unable to locate se_tpg->se_tpg_tfo pointer\n");
 		return -EINVAL;
 	}
 
@@ -553,11 +550,12 @@ int core_tpg_register(
 		}
 	}
 
-	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
-		 "Proto: %d, Portal Tag: %u\n", se_tpg->se_tpg_tfo->fabric_name,
-		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
-		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
-		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+	target_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
+		     "Proto: %d, Portal Tag: %u\n",
+		     se_tpg->se_tpg_tfo->fabric_name,
+		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
+		     se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
+		     se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	return 0;
 }
@@ -569,10 +567,10 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	struct se_node_acl *nacl, *nacl_tmp;
 	LIST_HEAD(node_list);
 
-	pr_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, "
-		 "Proto: %d, Portal Tag: %u\n", tfo->fabric_name,
-		tfo->tpg_get_wwn(se_tpg) ? tfo->tpg_get_wwn(se_tpg) : NULL,
-		se_tpg->proto_id, tfo->tpg_get_tag(se_tpg));
+	target_debug("TARGET_CORE[%s]: Deallocating portal_group for endpoint: %s, "
+		     "Proto: %d, Portal Tag: %u\n",
+		     tfo->fabric_name, tfo->tpg_get_wwn(se_tpg) ? tfo->tpg_get_wwn(se_tpg) : NULL,
+		     se_tpg->proto_id, tfo->tpg_get_tag(se_tpg));
 
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
 		cpu_relax();
@@ -612,7 +610,7 @@ struct se_lun *core_tpg_alloc_lun(
 
 	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
 	if (!lun) {
-		pr_err("Unable to allocate se_lun memory\n");
+		target_err("Unable to allocate se_lun memory\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	lun->unpacked_lun = unpacked_lun;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 73d0d6133ac8..65a7d8fb52ec 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -63,47 +63,47 @@ int init_se_kmem_caches(void)
 			sizeof(struct se_session), __alignof__(struct se_session),
 			0, NULL);
 	if (!se_sess_cache) {
-		pr_err("kmem_cache_create() for struct se_session"
-				" failed\n");
+		target_err("kmem_cache_create() for struct se_session"
+			   " failed\n");
 		goto out;
 	}
 	se_ua_cache = kmem_cache_create("se_ua_cache",
 			sizeof(struct se_ua), __alignof__(struct se_ua),
 			0, NULL);
 	if (!se_ua_cache) {
-		pr_err("kmem_cache_create() for struct se_ua failed\n");
+		target_err("kmem_cache_create() for struct se_ua failed\n");
 		goto out_free_sess_cache;
 	}
 	t10_pr_reg_cache = kmem_cache_create("t10_pr_reg_cache",
 			sizeof(struct t10_pr_registration),
 			__alignof__(struct t10_pr_registration), 0, NULL);
 	if (!t10_pr_reg_cache) {
-		pr_err("kmem_cache_create() for struct t10_pr_registration"
-				" failed\n");
+		target_err("kmem_cache_create() for struct t10_pr_registration"
+			   " failed\n");
 		goto out_free_ua_cache;
 	}
 	t10_alua_lu_gp_cache = kmem_cache_create("t10_alua_lu_gp_cache",
 			sizeof(struct t10_alua_lu_gp), __alignof__(struct t10_alua_lu_gp),
 			0, NULL);
 	if (!t10_alua_lu_gp_cache) {
-		pr_err("kmem_cache_create() for t10_alua_lu_gp_cache"
-				" failed\n");
+		target_err("kmem_cache_create() for t10_alua_lu_gp_cache"
+			   " failed\n");
 		goto out_free_pr_reg_cache;
 	}
 	t10_alua_lu_gp_mem_cache = kmem_cache_create("t10_alua_lu_gp_mem_cache",
 			sizeof(struct t10_alua_lu_gp_member),
 			__alignof__(struct t10_alua_lu_gp_member), 0, NULL);
 	if (!t10_alua_lu_gp_mem_cache) {
-		pr_err("kmem_cache_create() for t10_alua_lu_gp_mem_"
-				"cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lu_gp_mem_"
+			   "cache failed\n");
 		goto out_free_lu_gp_cache;
 	}
 	t10_alua_tg_pt_gp_cache = kmem_cache_create("t10_alua_tg_pt_gp_cache",
 			sizeof(struct t10_alua_tg_pt_gp),
 			__alignof__(struct t10_alua_tg_pt_gp), 0, NULL);
 	if (!t10_alua_tg_pt_gp_cache) {
-		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
-				"cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
+			   "cache failed\n");
 		goto out_free_lu_gp_mem_cache;
 	}
 	t10_alua_lba_map_cache = kmem_cache_create(
@@ -111,8 +111,8 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lba_map),
 			__alignof__(struct t10_alua_lba_map), 0, NULL);
 	if (!t10_alua_lba_map_cache) {
-		pr_err("kmem_cache_create() for t10_alua_lba_map_"
-				"cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lba_map_"
+			   "cache failed\n");
 		goto out_free_tg_pt_gp_cache;
 	}
 	t10_alua_lba_map_mem_cache = kmem_cache_create(
@@ -120,8 +120,8 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lba_map_member),
 			__alignof__(struct t10_alua_lba_map_member), 0, NULL);
 	if (!t10_alua_lba_map_mem_cache) {
-		pr_err("kmem_cache_create() for t10_alua_lba_map_mem_"
-				"cache failed\n");
+		target_err("kmem_cache_create() for t10_alua_lba_map_mem_"
+			   "cache failed\n");
 		goto out_free_lba_map_cache;
 	}
 
@@ -203,19 +203,19 @@ void transport_subsystem_check_init(void)
 
 	ret = IS_ENABLED(CONFIG_TCM_IBLOCK) && request_module("target_core_iblock");
 	if (ret != 0)
-		pr_err("Unable to load target_core_iblock\n");
+		target_err("Unable to load target_core_iblock\n");
 
 	ret = IS_ENABLED(CONFIG_TCM_FILEIO) && request_module("target_core_file");
 	if (ret != 0)
-		pr_err("Unable to load target_core_file\n");
+		target_err("Unable to load target_core_file\n");
 
 	ret = IS_ENABLED(CONFIG_TCM_PSCSI) && request_module("target_core_pscsi");
 	if (ret != 0)
-		pr_err("Unable to load target_core_pscsi\n");
+		target_err("Unable to load target_core_pscsi\n");
 
 	ret = IS_ENABLED(CONFIG_TCM_USER2) && request_module("target_core_user");
 	if (ret != 0)
-		pr_err("Unable to load target_core_user\n");
+		target_err("Unable to load target_core_user\n");
 
 	sub_api_initialized = 1;
 }
@@ -292,8 +292,8 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
-		pr_err("Unable to allocate struct se_session from"
-				" se_sess_cache\n");
+		target_err("Unable to allocate struct se_session from"
+			   " se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	transport_init_session(se_sess);
@@ -318,15 +318,16 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 	se_sess->sess_cmd_map = kvcalloc(tag_size, tag_num,
 					 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!se_sess->sess_cmd_map) {
-		pr_err("Unable to allocate se_sess->sess_cmd_map\n");
+		target_err("Unable to allocate se_sess->sess_cmd_map\n");
 		return -ENOMEM;
 	}
 
 	rc = sbitmap_queue_init_node(&se_sess->sess_tag_pool, tag_num, -1,
 			false, GFP_KERNEL, NUMA_NO_NODE);
 	if (rc < 0) {
-		pr_err("Unable to init se_sess->sess_tag_pool,"
-			" tag_num: %u\n", tag_num);
+		target_err("Unable to init se_sess->sess_tag_pool,"
+			   " tag_num: %u\n",
+			   tag_num);
 		kvfree(se_sess->sess_cmd_map);
 		se_sess->sess_cmd_map = NULL;
 		return -ENOMEM;
@@ -351,13 +352,15 @@ transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
 	int rc;
 
 	if (tag_num != 0 && !tag_size) {
-		pr_err("init_session_tags called with percpu-ida tag_num:"
-		       " %u, but zero tag_size\n", tag_num);
+		target_err("init_session_tags called with percpu-ida tag_num:"
+			   " %u, but zero tag_size\n",
+			   tag_num);
 		return ERR_PTR(-EINVAL);
 	}
 	if (!tag_num && tag_size) {
-		pr_err("init_session_tags called with percpu-ida tag_size:"
-		       " %u, but zero tag_num\n", tag_size);
+		target_err("init_session_tags called with percpu-ida tag_size:"
+			   " %u, but zero tag_num\n",
+			   tag_size);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -435,8 +438,8 @@ void __transport_register_session(
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
-		se_tpg->se_tpg_tfo->fabric_name, se_sess->fabric_sess_ptr);
+	target_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
+		     se_tpg->se_tpg_tfo->fabric_name, se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
 
@@ -671,8 +674,8 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 	target_for_each_device(target_release_res, se_sess);
 
-	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
-		se_tpg->se_tpg_tfo->fabric_name);
+	target_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
+		     se_tpg->se_tpg_tfo->fabric_name);
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
@@ -741,8 +744,7 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	 * this command for frontend exceptions.
 	 */
 	if (cmd->transport_state & CMD_T_STOP) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
-			__func__, __LINE__, cmd->tag);
+		target_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
@@ -806,8 +808,8 @@ static unsigned char *transport_get_sense_buffer(struct se_cmd *cmd)
 
 	cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
 
-	pr_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
-		dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
+	target_debug("HBA_[%u]_PLUG[%s]: Requesting sense for SAM STATUS: 0x%02x\n",
+		     dev->se_hba->hba_id, dev->transport->name, cmd->scsi_status);
 	return cmd->sense_buffer;
 }
 
@@ -835,13 +837,13 @@ static void target_handle_abort(struct se_cmd *cmd)
 	bool ack_kref = cmd->se_cmd_flags & SCF_ACK_KREF;
 	int ret;
 
-	pr_debug("tag %#llx: send_abort_response = %d\n", cmd->tag, tas);
+	target_debug("tag %#llx: send_abort_response = %d\n", cmd->tag, tas);
 
 	if (tas) {
 		if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
 			cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-			pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
-				 cmd->t_task_cdb[0], cmd->tag);
+			target_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
+				     cmd->t_task_cdb[0], cmd->tag);
 			trace_target_cmd_complete(cmd);
 			ret = cmd->se_tfo->queue_status(cmd);
 			if (ret) {
@@ -1014,11 +1016,12 @@ void target_qf_do_work(struct work_struct *work)
 		list_del(&cmd->se_qf_node);
 		atomic_dec_mb(&dev->dev_qf_count);
 
-		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
-			" context: %s\n", cmd->se_tfo->fabric_name, cmd,
-			(cmd->t_state == TRANSPORT_COMPLETE_QF_OK) ? "COMPLETE_OK" :
-			(cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING"
-			: "UNKNOWN");
+		target_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
+			     " context: %s\n",
+			     cmd->se_tfo->fabric_name, cmd,
+			     (cmd->t_state == TRANSPORT_COMPLETE_QF_OK) ? "COMPLETE_OK" :
+			     (cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING"
+			     : "UNKNOWN");
 
 		if (cmd->t_state == TRANSPORT_COMPLETE_QF_WP)
 			transport_write_pending_qf(cmd);
@@ -1114,7 +1117,7 @@ void transport_dump_vpd_proto_id(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		pr_debug("%s", buf);
+		target_debug("%s", buf);
 }
 
 void
@@ -1164,7 +1167,7 @@ int transport_dump_vpd_assoc(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		pr_debug("%s", buf);
+		target_debug("%s", buf);
 
 	return ret;
 }
@@ -1224,7 +1227,7 @@ int transport_dump_vpd_ident_type(
 			return -EINVAL;
 		strncpy(p_buf, buf, p_buf_len);
 	} else {
-		pr_debug("%s", buf);
+		target_debug("%s", buf);
 	}
 
 	return ret;
@@ -1278,7 +1281,7 @@ int transport_dump_vpd_ident(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		pr_debug("%s", buf);
+		target_debug("%s", buf);
 
 	return ret;
 }
@@ -1390,10 +1393,11 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 	if (cmd->unknown_data_length) {
 		cmd->data_length = size;
 	} else if (size != cmd->data_length) {
-		pr_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length:"
-			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
-			" 0x%02x\n", cmd->se_tfo->fabric_name,
-				cmd->data_length, size, cmd->t_task_cdb[0]);
+		target_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length:"
+					" %u does not match SCSI CDB Length: %u for SAM Opcode:"
+					" 0x%02x\n",
+					cmd->se_tfo->fabric_name, cmd->data_length, size,
+					cmd->t_task_cdb[0]);
 		/*
 		 * For READ command for the overflow case keep the existing
 		 * fabric provided ->data_length. Otherwise for the underflow
@@ -1417,8 +1421,8 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-				pr_err_ratelimited("Rejecting underflow/overflow"
-						   " for WRITE data CDB\n");
+				target_err_ratelimited("Rejecting underflow/overflow"
+						       " for WRITE data CDB\n");
 				return TCM_INVALID_FIELD_IN_COMMAND_IU;
 			}
 			/*
@@ -1428,8 +1432,8 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			 * is introduced tree-wide.
 			 */
 			if (size > cmd->data_length) {
-				pr_err_ratelimited("Rejecting overflow for"
-						   " WRITE control CDB\n");
+				target_err_ratelimited("Rejecting overflow for"
+						       " WRITE control CDB\n");
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
@@ -1492,8 +1496,8 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 		return 0;
 
 	if (cmd->sam_task_attr == TCM_ACA_TAG) {
-		pr_debug("SAM Task Attribute ACA"
-			" emulation is not supported\n");
+		target_debug("SAM Task Attribute ACA"
+			     " emulation is not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -1510,9 +1514,9 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	 * for VARIABLE_LENGTH_CMD
 	 */
 	if (scsi_command_size(cdb) > SCSI_MAX_VARLEN_CDB_SIZE) {
-		pr_err("Received SCSI CDB with command_size: %d that"
-			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
-			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
+		target_err("Received SCSI CDB with command_size: %d that"
+			   " exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+			   scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
 		ret = TCM_INVALID_CDB_FIELD;
 		goto err;
 	}
@@ -1524,10 +1528,10 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
-			pr_err("Unable to allocate cmd->t_task_cdb"
-				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
-				scsi_command_size(cdb),
-				(unsigned long)sizeof(cmd->__t_task_cdb));
+			target_err("Unable to allocate cmd->t_task_cdb"
+				   " %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
+				   scsi_command_size(cdb),
+				   (unsigned long)sizeof(cmd->__t_task_cdb));
 			ret = TCM_OUT_OF_RESOURCES;
 			goto err;
 		}
@@ -1559,10 +1563,10 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
-		pr_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
-				     cmd->se_tfo->fabric_name,
-				     cmd->se_sess->se_node_acl->initiatorname,
-				     cmd->t_task_cdb[0]);
+		target_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
+					 cmd->se_tfo->fabric_name,
+					 cmd->se_sess->se_node_acl->initiatorname,
+					 cmd->t_task_cdb[0]);
 	if (ret)
 		return ret;
 
@@ -1611,7 +1615,7 @@ static int __target_submit(struct se_cmd *cmd)
 
 	if (!cmd->se_lun) {
 		dump_stack();
-		pr_err("cmd->se_lun is NULL\n");
+		target_err("cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1650,8 +1654,8 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 	 * passes for the original expected data transfer length.
 	 */
 	if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
-		pr_warn("Rejecting SCSI DATA overflow for fabric using"
-			" SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
+		target_warn("Rejecting SCSI DATA overflow for fabric using"
+			    " SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2034,8 +2038,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 {
 	int ret = 0, post_ret;
 
-	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
-		 sense_reason);
+	target_debug("-----[ Storage Engine Exception; sense_reason %d\n", sense_reason);
 	target_show_cmd("-----[ ", cmd);
 
 	/*
@@ -2109,8 +2112,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 
 		goto queue_status;
 	default:
-		pr_err("Unknown transport error for CDB 0x%02x: %d\n",
-			cmd->t_task_cdb[0], sense_reason);
+		target_err("Unknown transport error for CDB 0x%02x: %d\n", cmd->t_task_cdb[0],
+			   sense_reason);
 		sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
 		break;
 	}
@@ -2226,14 +2229,12 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	switch (cmd->sam_task_attr) {
 	case TCM_HEAD_TAG:
 		atomic_inc_mb(&dev->non_ordered);
-		pr_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n",
-			 cmd->t_task_cdb[0]);
+		target_debug("Added HEAD_OF_QUEUE for CDB: 0x%02x\n", cmd->t_task_cdb[0]);
 		return false;
 	case TCM_ORDERED_TAG:
 		atomic_inc_mb(&dev->delayed_cmd_count);
 
-		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list\n",
-			 cmd->t_task_cdb[0]);
+		target_debug("Added ORDERED for CDB: 0x%02x to ordered list\n", cmd->t_task_cdb[0]);
 		break;
 	default:
 		/*
@@ -2263,8 +2264,8 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
 	spin_unlock(&dev->delayed_cmd_lock);
 
-	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn",
-		cmd->t_task_cdb[0], cmd->sam_task_attr);
+	target_debug("Added CDB: 0x%02x Task Attr: 0x%02x to delayed CMD listn", cmd->t_task_cdb[0],
+		     cmd->sam_task_attr);
 	/*
 	 * We may have no non ordered cmds when this function started or we
 	 * could have raced with the last simple/head cmd completing, so kick
@@ -2368,16 +2369,16 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	} else if (cmd->sam_task_attr == TCM_HEAD_TAG) {
 		atomic_dec_mb(&dev->non_ordered);
 		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
-			 dev->dev_cur_ordered_id);
+		target_debug("Incremented dev_cur_ordered_id: %u for HEAD_OF_QUEUE\n",
+			     dev->dev_cur_ordered_id);
 	} else if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
 		spin_lock(&dev->delayed_cmd_lock);
 		dev->ordered_sync_in_progress = false;
 		spin_unlock(&dev->delayed_cmd_lock);
 
 		dev->dev_cur_ordered_id++;
-		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
-			 dev->dev_cur_ordered_id);
+		target_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
+			     dev->dev_cur_ordered_id);
 	}
 	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
 
@@ -2469,7 +2470,7 @@ static void transport_handle_queue_full(struct se_cmd *cmd, struct se_device *de
 		cmd->t_state = (write_pending) ? TRANSPORT_COMPLETE_QF_WP :
 						 TRANSPORT_COMPLETE_QF_OK;
 	} else {
-		pr_warn_ratelimited("Got unknown fabric queue status: %d\n", err);
+		target_warn_ratelimited("Got unknown fabric queue status: %d\n", err);
 		cmd->t_state = TRANSPORT_COMPLETE_QF_ERR;
 	}
 
@@ -2648,8 +2649,9 @@ static void target_complete_ok_work(struct work_struct *work)
 	return;
 
 queue_full:
-	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
-		" data_direction: %d\n", cmd, cmd->data_direction);
+	target_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
+		     " data_direction: %d\n",
+		     cmd, cmd->data_direction);
 
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
@@ -2854,8 +2856,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	if (cmd->transport_state & CMD_T_STOP &&
 	    !cmd->se_tfo->write_pending_must_be_called) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
-			 __func__, __LINE__, cmd->tag);
+		target_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n", __func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
@@ -2872,7 +2873,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	return 0;
 
 queue_full:
-	pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
+	target_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	return 0;
 }
@@ -2889,16 +2890,15 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (stop) {
-		pr_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
-			__func__, __LINE__, cmd->tag);
+		target_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n", __func__,
+			     __LINE__, cmd->tag);
 		complete_all(&cmd->t_transport_stop_comp);
 		return;
 	}
 
 	ret = cmd->se_tfo->write_pending(cmd);
 	if (ret) {
-		pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n",
-			 cmd);
+		target_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, true);
 	}
 }
@@ -2978,7 +2978,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		cmd->free_compl = &compl;
 	ret = target_put_sess_cmd(cmd);
 	if (aborted) {
-		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
+		target_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		wait_for_completion(&compl);
 		ret = 1;
 	}
@@ -3147,18 +3147,15 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 	struct se_tmr_req *tmf = cmd->se_tmr_req;
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
-		pr_debug("%scmd %#02x:%#02x with tag %#llx dir %s i_state %d t_state %s len %d refcnt %d transport_state %s\n",
-			 pfx, cdb[0], cdb[1], cmd->tag,
-			 data_dir_name(cmd->data_direction),
-			 cmd->se_tfo->get_cmd_state(cmd),
-			 cmd_state_name(cmd->t_state), cmd->data_length,
-			 kref_read(&cmd->cmd_kref), ts_str);
+		target_debug("%scmd %#02x:%#02x with tag %#llx dir %s i_state %d t_state %s len %d refcnt %d transport_state %s\n",
+			     pfx, cdb[0], cdb[1], cmd->tag, data_dir_name(cmd->data_direction),
+			     cmd->se_tfo->get_cmd_state(cmd), cmd_state_name(cmd->t_state),
+			     cmd->data_length, kref_read(&cmd->cmd_kref), ts_str);
 	} else {
-		pr_debug("%stmf %s with tag %#llx ref_task_tag %#llx i_state %d t_state %s refcnt %d transport_state %s\n",
-			 pfx, target_tmf_name(tmf->function), cmd->tag,
-			 tmf->ref_task_tag, cmd->se_tfo->get_cmd_state(cmd),
-			 cmd_state_name(cmd->t_state),
-			 kref_read(&cmd->cmd_kref), ts_str);
+		target_debug("%stmf %s with tag %#llx ref_task_tag %#llx i_state %d t_state %s refcnt %d transport_state %s\n",
+			     pfx, target_tmf_name(tmf->function), cmd->tag, tmf->ref_task_tag,
+			     cmd->se_tfo->get_cmd_state(cmd), cmd_state_name(cmd->t_state),
+			     kref_read(&cmd->cmd_kref), ts_str);
 	}
 	kfree(ts_str);
 }
@@ -3178,7 +3175,7 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
  */
 void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
-	pr_debug("Stopping command counter.\n");
+	target_debug("Stopping command counter.\n");
 	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
 		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
 					    target_stop_cmd_counter_confirm);
@@ -3206,14 +3203,14 @@ void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
-		pr_debug("Waiting for running cmds to complete.\n");
+		target_debug("Waiting for running cmds to complete.\n");
 		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
 					 percpu_ref_is_zero(&cmd_cnt->refcnt),
 					 180 * HZ);
 	} while (ret <= 0);
 
 	wait_for_completion(&cmd_cnt->stop_done);
-	pr_debug("Waiting for cmds done.\n");
+	target_debug("Waiting for cmds done.\n");
 }
 EXPORT_SYMBOL_GPL(target_wait_for_cmds);
 
@@ -3281,8 +3278,9 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	spin_lock_irqsave(&cmd->t_state_lock, *flags);
 	cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
 
-	pr_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->"
-		 "t_transport_stop_comp) for ITT: 0x%08llx\n", cmd->tag);
+	target_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->"
+		     "t_transport_stop_comp) for ITT: 0x%08llx\n",
+		     cmd->tag);
 
 	return true;
 }
@@ -3604,8 +3602,7 @@ static void target_tmr_work(struct work_struct *work)
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	default:
-		pr_err("Unknown TMR function: 0x%02x.\n",
-				tmr->function);
+		target_err("Unknown TMR function: 0x%02x.\n", tmr->function);
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	}
@@ -3643,9 +3640,9 @@ int transport_generic_handle_tmr(
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (aborted) {
-		pr_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d ref_tag: %llu tag: %llu\n",
-				    cmd->se_tmr_req->function,
-				    cmd->se_tmr_req->ref_task_tag, cmd->tag);
+		target_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d ref_tag: %llu tag: %llu\n",
+					cmd->se_tmr_req->function, cmd->se_tmr_req->ref_task_tag,
+					cmd->tag);
 		target_handle_abort(cmd);
 		return 0;
 	}
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 4276690fb6cb..825039a5be08 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -81,7 +81,7 @@ int core_scsi3_ua_allocate(
 
 	ua = kmem_cache_zalloc(se_ua_cache, GFP_ATOMIC);
 	if (!ua) {
-		pr_err("Unable to allocate struct se_ua\n");
+		target_err("Unable to allocate struct se_ua\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&ua->ua_nacl_list);
@@ -146,9 +146,9 @@ int core_scsi3_ua_allocate(
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
 
-	pr_debug("Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
-		" 0x%02x, ASCQ: 0x%02x\n", deve->mapped_lun,
-		asc, ascq);
+	target_debug("Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
+		     " 0x%02x, ASCQ: 0x%02x\n",
+		     deve->mapped_lun, asc, ascq);
 
 	return 0;
 }
@@ -252,13 +252,13 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	pr_debug("[%s]: %s UNIT ATTENTION condition with"
-		" INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x"
-		" reported ASC: 0x%02x, ASCQ: 0x%02x\n",
-		nacl->se_tpg->se_tpg_tfo->fabric_name,
-		dev_ua_intlck_clear ? "Releasing" : "Reporting",
-		dev->dev_attrib.emulate_ua_intlck_ctrl,
-		cmd->orig_fe_lun, cmd->t_task_cdb[0], *asc, *ascq);
+	target_debug("[%s]: %s UNIT ATTENTION condition with"
+		     " INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x"
+		     " reported ASC: 0x%02x, ASCQ: 0x%02x\n",
+		     nacl->se_tpg->se_tpg_tfo->fabric_name,
+		     dev_ua_intlck_clear ? "Releasing" : "Reporting",
+		     dev->dev_attrib.emulate_ua_intlck_ctrl, cmd->orig_fe_lun, cmd->t_task_cdb[0],
+		     *asc, *ascq);
 
 	return head == 0;
 }
@@ -314,10 +314,10 @@ int core_scsi3_ua_clear_for_request_sense(
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
-	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
-		" LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
-		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->fabric_name,
-		cmd->orig_fe_lun, *asc, *ascq);
+	target_debug("[%s]: Released UNIT ATTENTION condition, mapped"
+		     " LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
+		     " ASCQ: 0x%02x\n",
+		     nacl->se_tpg->se_tpg_tfo->fabric_name, cmd->orig_fe_lun, *asc, *ascq);
 
 	return (head) ? -EPERM : 0;
 }
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7eb94894bd68..4e4c3fcb9ca8 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -236,7 +236,7 @@ static int tcmu_set_global_max_data_area(const char *str,
 		return -EINVAL;
 
 	if (max_area_mb <= 0) {
-		pr_err("global_max_data_area must be larger than 0.\n");
+		target_err("global_max_data_area must be larger than 0.\n");
 		return -EINVAL;
 	}
 
@@ -284,7 +284,7 @@ static int tcmu_set_block_netlink(const char *str,
 		return ret;
 
 	if (val > 1) {
-		pr_err("Invalid block netlink value %u\n", val);
+		target_err("Invalid block netlink value %u\n", val);
 		return -EINVAL;
 	}
 
@@ -305,12 +305,12 @@ static int tcmu_fail_netlink_cmd(struct tcmu_nl_cmd *nl_cmd)
 	struct tcmu_dev *udev = nl_cmd->udev;
 
 	if (!tcmu_netlink_blocked) {
-		pr_err("Could not reset device's netlink interface. Netlink is not blocked.\n");
+		target_err("Could not reset device's netlink interface. Netlink is not blocked.\n");
 		return -EBUSY;
 	}
 
 	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
-		pr_debug("Aborting nl cmd %d on %s\n", nl_cmd->cmd, udev->name);
+		target_debug("Aborting nl cmd %d on %s\n", nl_cmd->cmd, udev->name);
 		nl_cmd->status = -EINTR;
 		list_del(&nl_cmd->nl_list);
 		complete(&nl_cmd->complete);
@@ -330,7 +330,7 @@ static int tcmu_set_reset_netlink(const char *str,
 		return ret;
 
 	if (val != 1) {
-		pr_err("Invalid reset netlink value %u\n", val);
+		target_err("Invalid reset netlink value %u\n", val);
 		return -EINVAL;
 	}
 
@@ -377,7 +377,7 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 
 	if (!info->attrs[TCMU_ATTR_CMD_STATUS] ||
 	    !info->attrs[TCMU_ATTR_DEVICE_ID]) {
-		printk(KERN_ERR "TCMU_ATTR_CMD_STATUS or TCMU_ATTR_DEVICE_ID not set, doing nothing\n");
+		target_err("TCMU_ATTR_CMD_STATUS or TCMU_ATTR_DEVICE_ID not set, doing nothing\n");
 		return -EINVAL;
         }
 
@@ -393,20 +393,19 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	}
 
 	if (!udev) {
-		pr_err("tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
-		       completed_cmd, rc, dev_id);
+		target_err("tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
+			   completed_cmd, rc, dev_id);
 		ret = -ENODEV;
 		goto unlock;
 	}
 	list_del(&nl_cmd->nl_list);
 
-	pr_debug("%s genl cmd done got id %d curr %d done %d rc %d stat %d\n",
-		 udev->name, dev_id, nl_cmd->cmd, completed_cmd, rc,
-		 nl_cmd->status);
+	target_debug("%s genl cmd done got id %d curr %d done %d rc %d stat %d\n", udev->name,
+		     dev_id, nl_cmd->cmd, completed_cmd, rc, nl_cmd->status);
 
 	if (nl_cmd->cmd != completed_cmd) {
-		pr_err("Mismatched commands on %s (Expecting reply for %d. Current %d).\n",
-		       udev->name, completed_cmd, nl_cmd->cmd);
+		target_err("Mismatched commands on %s (Expecting reply for %d. Current %d).\n",
+			   udev->name, completed_cmd, nl_cmd->cmd);
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -439,8 +438,8 @@ static int tcmu_genl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[TCMU_ATTR_SUPP_KERN_CMD_REPLY]) {
 		tcmu_kern_cmd_reply_supported  =
 			nla_get_u8(info->attrs[TCMU_ATTR_SUPP_KERN_CMD_REPLY]);
-		printk(KERN_INFO "tcmu daemon: command reply support %u.\n",
-		       tcmu_kern_cmd_reply_supported);
+		target_info("tcmu daemon: command reply support %u.\n",
+			    tcmu_kern_cmd_reply_supported);
 	}
 
 	return 0;
@@ -744,8 +743,8 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 				if (!sg_miter_next(&sg_iter)) {
 					/* set length to 0 to abort outer loop */
 					data_len = 0;
-					pr_debug("%s: aborting data copy due to exhausted sg_list\n",
-						 __func__);
+					target_debug("%s: aborting data copy due to exhausted sg_list\n",
+						     __func__);
 					break;
 				}
 				cp_len = min3(sg_iter.length, page_remaining,
@@ -838,8 +837,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size)
 
 	space = spc_free(cmd_head, udev->cmdr_last_cleaned, udev->cmdr_size);
 	if (space < cmd_needed) {
-		pr_debug("no cmd space: %u %u %u\n", cmd_head,
-		       udev->cmdr_last_cleaned, udev->cmdr_size);
+		target_debug("no cmd space: %u %u %u\n", cmd_head, udev->cmdr_last_cleaned,
+			     udev->cmdr_size);
 		return false;
 	}
 	return true;
@@ -866,9 +865,9 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 				(udev->max_blocks - udev->dbi_thresh) + space;
 
 		if (blocks_left < cmd->dbi_cnt) {
-			pr_debug("no data space: only %lu available, but ask for %u\n",
-					blocks_left * udev->data_blk_size,
-					cmd->dbi_cnt * udev->data_blk_size);
+			target_debug("no data space: only %lu available, but ask for %u\n",
+				     blocks_left * udev->data_blk_size,
+				     cmd->dbi_cnt * udev->data_blk_size);
 			return -1;
 		}
 
@@ -922,8 +921,8 @@ static void tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
 	if (!timer_pending(timer))
 		mod_timer(timer, tcmu_cmd->deadline);
 
-	pr_debug("Timeout set up for cmd %p, dev = %s, tmo = %lu\n", tcmu_cmd,
-		 tcmu_cmd->tcmu_dev->name, tmo / MSEC_PER_SEC);
+	target_debug("Timeout set up for cmd %p, dev = %s, tmo = %lu\n", tcmu_cmd,
+		     tcmu_cmd->tcmu_dev->name, tmo / MSEC_PER_SEC);
 }
 
 static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
@@ -947,8 +946,7 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->qfull_queue);
-	pr_debug("adding cmd %p on dev %s to ring space wait queue\n",
-		 tcmu_cmd, udev->name);
+	target_debug("adding cmd %p on dev %s to ring space wait queue\n", tcmu_cmd, udev->name);
 	return 0;
 }
 
@@ -1040,8 +1038,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		goto queue;
 
 	if (data_length > (size_t)udev->max_blocks * blk_size) {
-		pr_warn("TCMU: Request of size %zu is too big for %zu data area\n",
-			data_length, (size_t)udev->max_blocks * blk_size);
+		target_warn("TCMU: Request of size %zu is too big for %zu data area\n", data_length,
+			    (size_t)udev->max_blocks * blk_size);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
 	}
@@ -1058,8 +1056,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	if (command_size > (udev->cmdr_size / 2)) {
-		pr_warn("TCMU: Request of size %zu is too big for %u cmd ring\n",
-			command_size, udev->cmdr_size);
+		target_warn("TCMU: Request of size %zu is too big for %u cmd ring\n", command_size,
+			    udev->cmdr_size);
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
@@ -1074,7 +1072,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
 		     GFP_NOWAIT) < 0) {
-		pr_err("tcmu: Could not allocate cmd id.\n");
+		target_err("tcmu: Could not allocate cmd id.\n");
 
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 		*scsi_err = TCM_OUT_OF_RESOURCES;
@@ -1082,8 +1080,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	}
 	tcmu_cmd->cmd_id = cmd_id;
 
-	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
-		 tcmu_cmd, udev->name);
+	target_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id, tcmu_cmd,
+		     udev->name);
 
 	cmd_head = ring_insert_padding(udev, command_size);
 
@@ -1172,8 +1170,8 @@ queue_tmr_ring(struct tcmu_dev *udev, struct tcmu_tmr *tmr)
 	if (!list_empty(&udev->tmr_queue) ||
 	    !is_ring_space_avail(udev, cmd_size)) {
 		list_add_tail(&tmr->queue_entry, &udev->tmr_queue);
-		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
-			 tmr, udev->name);
+		target_debug("adding tmr %p on dev %s to TMR ring space wait queue\n", tmr,
+			     udev->name);
 		return 1;
 	}
 
@@ -1275,8 +1273,8 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 			cmd_cnt++;
 			continue;
 		}
-		pr_debug("Removing aborted command %p from queue on dev %s.\n",
-			 cmd, udev->name);
+		target_debug("Removing aborted command %p from queue on dev %s.\n", cmd,
+			     udev->name);
 
 		list_del_init(&cmd->queue_entry);
 		tcmu_free_cmd(cmd);
@@ -1290,8 +1288,8 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags))
 		goto unlock;
 
-	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
-		 tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
+	target_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
+		     tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
 
 	tmr = kmalloc(struct_size(tmr, tmr_cmd_ids, cmd_cnt), GFP_NOIO);
 	if (!tmr)
@@ -1335,8 +1333,8 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 		goto out;
 	}
 	if (test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
-		pr_err("cmd_id %u already completed with KEEP_BUF, ring is broken\n",
-		       entry->hdr.cmd_id);
+		target_err("cmd_id %u already completed with KEEP_BUF, ring is broken\n",
+			   entry->hdr.cmd_id);
 		set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 		ret = false;
 		goto out;
@@ -1347,8 +1345,7 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 	tcmu_cmd_reset_dbi_cur(cmd);
 
 	if (entry->hdr.uflags & TCMU_UFLAG_UNKNOWN_OP) {
-		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
-			cmd->se_cmd);
+		target_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n", cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 		goto done;
 	}
@@ -1376,14 +1373,13 @@ static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
 		/* TODO: */
 	} else if (se_cmd->data_direction != DMA_NONE) {
-		pr_warn("TCMU: data direction was %d!\n",
-			se_cmd->data_direction);
+		target_warn("TCMU: data direction was %d!\n", se_cmd->data_direction);
 	}
 
 done:
 	se_cmd->priv = NULL;
 	if (read_len_valid) {
-		pr_debug("read_len = %d\n", read_len);
+		target_debug("read_len = %d\n", read_len);
 		target_complete_cmd_with_length(cmd->se_cmd,
 					entry->rsp.scsi_status, read_len);
 	} else
@@ -1416,18 +1412,17 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	if (list_empty(&udev->tmr_queue))
 		return 1;
 
-	pr_debug("running %s's tmr queue\n", udev->name);
+	target_debug("running %s's tmr queue\n", udev->name);
 
 	list_splice_init(&udev->tmr_queue, &tmrs);
 
 	list_for_each_entry_safe(tmr, tmp, &tmrs, queue_entry) {
 		list_del_init(&tmr->queue_entry);
 
-		pr_debug("removing tmr %p on dev %s from queue\n",
-			 tmr, udev->name);
+		target_debug("removing tmr %p on dev %s from queue\n", tmr, udev->name);
 
 		if (queue_tmr_ring(udev, tmr)) {
-			pr_debug("ran out of space during tmr queue run\n");
+			target_debug("ran out of space during tmr queue run\n");
 			/*
 			 * tmr was requeued, so just put all tmrs back in
 			 * the queue
@@ -1447,7 +1442,7 @@ static bool tcmu_handle_completions(struct tcmu_dev *udev)
 	bool free_space = false;
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
-		pr_err("ring broken, not handling completions\n");
+		target_err("ring broken, not handling completions\n");
 		return false;
 	}
 
@@ -1485,8 +1480,7 @@ static bool tcmu_handle_completions(struct tcmu_dev *udev)
 		else
 			cmd = xa_erase(&udev->commands, entry->hdr.cmd_id);
 		if (!cmd) {
-			pr_err("cmd_id %u not found, ring is broken\n",
-			       entry->hdr.cmd_id);
+			target_err("cmd_id %u not found, ring is broken\n", entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 			return false;
 		}
@@ -1528,8 +1522,7 @@ static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 	se_cmd->priv = NULL;
 	cmd->se_cmd = NULL;
 
-	pr_debug("Timing out inflight cmd %u on dev %s.\n",
-		 cmd->cmd_id, cmd->tcmu_dev->name);
+	target_debug("Timing out inflight cmd %u on dev %s.\n", cmd->cmd_id, cmd->tcmu_dev->name);
 
 	target_complete_cmd(se_cmd, SAM_STAT_CHECK_CONDITION);
 }
@@ -1541,8 +1534,7 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	if (!time_after_eq(jiffies, cmd->deadline))
 		return;
 
-	pr_debug("Timing out queued cmd %p on dev %s.\n",
-		  cmd, cmd->tcmu_dev->name);
+	target_debug("Timing out queued cmd %p on dev %s.\n", cmd, cmd->tcmu_dev->name);
 
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
@@ -1566,7 +1558,7 @@ static void tcmu_cmd_timedout(struct timer_list *t)
 {
 	struct tcmu_dev *udev = from_timer(udev, t, cmd_timer);
 
-	pr_debug("%s cmd timeout has expired\n", udev->name);
+	target_debug("%s cmd timeout has expired\n", udev->name);
 	tcmu_device_timedout(udev);
 }
 
@@ -1574,7 +1566,7 @@ static void tcmu_qfull_timedout(struct timer_list *t)
 {
 	struct tcmu_dev *udev = from_timer(udev, t, qfull_timer);
 
-	pr_debug("%s qfull timeout has expired\n", udev->name);
+	target_debug("%s qfull timeout has expired\n", udev->name);
 	tcmu_device_timedout(udev);
 }
 
@@ -1742,7 +1734,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
-	pr_debug("dev_kref_release\n");
+	target_debug("dev_kref_release\n");
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
@@ -1757,15 +1749,14 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 	if (list_empty(&udev->qfull_queue))
 		return;
 
-	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
+	target_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
 	list_splice_init(&udev->qfull_queue, &cmds);
 
 	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
 		list_del_init(&tcmu_cmd->queue_entry);
 
-		pr_debug("removing cmd %p on dev %s from queue\n",
-			 tcmu_cmd, udev->name);
+		target_debug("removing cmd %p on dev %s from queue\n", tcmu_cmd, udev->name);
 
 		if (fail) {
 			/*
@@ -1783,8 +1774,8 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 		if (ret < 0) {
-			pr_debug("cmd %p on dev %s failed with %u\n",
-				 tcmu_cmd, udev->name, scsi_ret);
+			target_debug("cmd %p on dev %s failed with %u\n", tcmu_cmd, udev->name,
+				     scsi_ret);
 			/*
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
@@ -1794,7 +1785,7 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 					    SAM_STAT_CHECK_CONDITION);
 			tcmu_free_cmd(tcmu_cmd);
 		} else if (ret > 0) {
-			pr_debug("ran out of space during cmdr queue run\n");
+			target_debug("ran out of space during cmdr queue run\n");
 			/*
 			 * cmd was requeued, so just put all cmds back in
 			 * the queue
@@ -1853,8 +1844,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	 * Userspace messed up and passed in a address not in the
 	 * data iov passed to it.
 	 */
-	pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
-	       dpi, udev->name);
+	target_err("Invalid addr to data page mapping (dpi %u) on device %s\n", dpi, udev->name);
 	mutex_unlock(&udev->cmdr_lock);
 
 	return NULL;
@@ -1864,7 +1854,7 @@ static void tcmu_vma_open(struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = vma->vm_private_data;
 
-	pr_debug("vma_open\n");
+	target_debug("vma_open\n");
 
 	kref_get(&udev->kref);
 }
@@ -1873,7 +1863,7 @@ static void tcmu_vma_close(struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = vma->vm_private_data;
 
-	pr_debug("vma_close\n");
+	target_debug("vma_close\n");
 
 	/* release ref from tcmu_vma_open */
 	kref_put(&udev->kref, tcmu_dev_kref_release);
@@ -1952,7 +1942,7 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 
 	udev->inode = inode;
 
-	pr_debug("open\n");
+	target_debug("open\n");
 
 	return 0;
 }
@@ -1976,8 +1966,8 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 		 */
 		if (!test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags))
 			continue;
-		pr_debug("removing KEEP_BUF cmd %u on dev %s from ring\n",
-			 cmd->cmd_id, udev->name);
+		target_debug("removing KEEP_BUF cmd %u on dev %s from ring\n", cmd->cmd_id,
+			     udev->name);
 		freed = true;
 
 		xa_erase(&udev->commands, i);
@@ -1995,7 +1985,7 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 
 	clear_bit(TCMU_DEV_BIT_OPEN, &udev->flags);
 
-	pr_debug("close\n");
+	target_debug("close\n");
 
 	return 0;
 }
@@ -2014,15 +2004,13 @@ static int tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 
 	if (tcmu_netlink_blocked) {
 		mutex_unlock(&tcmu_nl_cmd_mutex);
-		pr_warn("Failing nl cmd %d on %s. Interface is blocked.\n", cmd,
-			udev->name);
+		target_warn("Failing nl cmd %d on %s. Interface is blocked.\n", cmd, udev->name);
 		return -EAGAIN;
 	}
 
 	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
 		mutex_unlock(&tcmu_nl_cmd_mutex);
-		pr_warn("netlink cmd %d already executing on %s\n",
-			 nl_cmd->cmd, udev->name);
+		target_warn("netlink cmd %d already executing on %s\n", nl_cmd->cmd, udev->name);
 		return -EBUSY;
 	}
 
@@ -2067,7 +2055,7 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	if (udev->nl_reply_supported <= 0)
 		return 0;
 
-	pr_debug("sleeping for nl reply\n");
+	target_debug("sleeping for nl reply\n");
 	wait_for_completion(&nl_cmd->complete);
 
 	mutex_lock(&tcmu_nl_cmd_mutex);
@@ -2368,12 +2356,10 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	xa_for_each(&udev->commands, i, cmd) {
-		pr_debug("removing cmd %u on dev %s from ring %s\n",
-			 cmd->cmd_id, udev->name,
-			 test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) ?
-			 "(is expired)" :
-			 (test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags) ?
-			 "(is keep buffer)" : ""));
+		target_debug("removing cmd %u on dev %s from ring %s\n", cmd->cmd_id, udev->name,
+			     test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) ? "(is expired)" :
+			     (test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags) ? "(is keep buffer)" :
+			     ""));
 
 		xa_erase(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) &&
@@ -2399,8 +2385,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 	mb = udev->mb_addr;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
-	pr_debug("mb last %u head %u tail %u\n", udev->cmdr_last_cleaned,
-		 mb->cmd_tail, mb->cmd_head);
+	target_debug("mb last %u head %u tail %u\n", udev->cmdr_last_cleaned, mb->cmd_tail,
+		     mb->cmd_head);
 
 	udev->cmdr_last_cleaned = 0;
 	mb->cmd_tail = 0;
@@ -2448,14 +2434,12 @@ static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
-		pr_err("match_int() failed for dev attrib. Error %d.\n",
-		       ret);
+		target_err("match_int() failed for dev attrib. Error %d.\n", ret);
 		return ret;
 	}
 
 	if (val <= 0) {
-		pr_err("Invalid dev attrib value %d. Must be greater than zero.\n",
-		       val);
+		target_err("Invalid dev attrib value %d. Must be greater than zero.\n", val);
 		return -EINVAL;
 	}
 	*dev_attrib = val;
@@ -2469,28 +2453,27 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
-		pr_err("match_int() failed for max_data_area_mb=. Error %d.\n",
-		       ret);
+		target_err("match_int() failed for max_data_area_mb=. Error %d.\n", ret);
 		return ret;
 	}
 	if (val <= 0) {
-		pr_err("Invalid max_data_area %d.\n", val);
+		target_err("Invalid max_data_area %d.\n", val);
 		return -EINVAL;
 	}
 	if (val > TCMU_PAGES_TO_MBS(tcmu_global_max_pages)) {
-		pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
-		       val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
+		target_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
+			   val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
 		val = TCMU_PAGES_TO_MBS(tcmu_global_max_pages);
 	}
 	if (TCMU_MBS_TO_PAGES(val) < pages_per_blk) {
-		pr_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%u pages).\n",
-		       val, TCMU_MBS_TO_PAGES(val), pages_per_blk);
+		target_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%u pages).\n",
+			   val, TCMU_MBS_TO_PAGES(val), pages_per_blk);
 		return -EINVAL;
 	}
 
 	mutex_lock(&udev->cmdr_lock);
 	if (udev->data_bitmap) {
-		pr_err("Cannot set max_data_area_mb after it has been enabled.\n");
+		target_err("Cannot set max_data_area_mb after it has been enabled.\n");
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -2509,21 +2492,19 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
-		pr_err("match_int() failed for data_pages_per_blk=. Error %d.\n",
-		       ret);
+		target_err("match_int() failed for data_pages_per_blk=. Error %d.\n", ret);
 		return ret;
 	}
 
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
-		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
-		       val, udev->data_area_mb,
-		       TCMU_MBS_TO_PAGES(udev->data_area_mb));
+		target_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
+			   val, udev->data_area_mb, TCMU_MBS_TO_PAGES(udev->data_area_mb));
 		return -EINVAL;
 	}
 
 	mutex_lock(&udev->cmdr_lock);
 	if (udev->data_bitmap) {
-		pr_err("Cannot set data_pages_per_blk after it has been enabled.\n");
+		target_err("Cannot set data_pages_per_blk after it has been enabled.\n");
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -2542,27 +2523,26 @@ static int tcmu_set_cmd_ring_size(struct tcmu_dev *udev, substring_t *arg)
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
-		pr_err("match_int() failed for cmd_ring_size_mb=. Error %d.\n",
-		       ret);
+		target_err("match_int() failed for cmd_ring_size_mb=. Error %d.\n", ret);
 		return ret;
 	}
 
 	if (val <= 0) {
-		pr_err("Invalid cmd_ring_size_mb %d.\n", val);
+		target_err("Invalid cmd_ring_size_mb %d.\n", val);
 		return -EINVAL;
 	}
 
 	mutex_lock(&udev->cmdr_lock);
 	if (udev->data_bitmap) {
-		pr_err("Cannot set cmd_ring_size_mb after it has been enabled.\n");
+		target_err("Cannot set cmd_ring_size_mb after it has been enabled.\n");
 		ret = -EINVAL;
 		goto unlock;
 	}
 
 	udev->cmdr_size = (val << 20) - CMDR_OFF;
 	if (val > (MB_CMDR_SIZE_DEF >> 20)) {
-		pr_err("%d is too large. Adjusting cmd_ring_size_mb to global limit of %u\n",
-		       val, (MB_CMDR_SIZE_DEF >> 20));
+		target_err("%d is too large. Adjusting cmd_ring_size_mb to global limit of %u\n",
+			   val, (MB_CMDR_SIZE_DEF >> 20));
 		udev->cmdr_size = CMDR_SIZE_DEF;
 	}
 
@@ -2597,13 +2577,12 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			pr_debug("TCMU: Referencing Path: %s\n", udev->dev_config);
+			target_debug("TCMU: Referencing Path: %s\n", udev->dev_config);
 			break;
 		case Opt_dev_size:
 			ret = match_u64(&args[0], &udev->dev_size);
 			if (ret < 0)
-				pr_err("match_u64() failed for dev_size=. Error %d.\n",
-				       ret);
+				target_err("match_u64() failed for dev_size=. Error %d.\n", ret);
 			break;
 		case Opt_hw_block_size:
 			ret = tcmu_set_dev_attrib(&args[0],
@@ -2616,8 +2595,8 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 		case Opt_nl_reply_supported:
 			ret = match_int(&args[0], &udev->nl_reply_supported);
 			if (ret < 0)
-				pr_err("match_int() failed for nl_reply_supported=. Error %d.\n",
-				       ret);
+				target_err("match_int() failed for nl_reply_supported=. Error %d.\n",
+					   ret);
 			break;
 		case Opt_max_data_area_mb:
 			ret = tcmu_set_max_blocks_param(udev, &args[0]);
@@ -2690,7 +2669,7 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 	int ret;
 
 	if (da->da_dev->export_count) {
-		pr_err("Unable to set tcmu cmd_time_out while exports exist\n");
+		target_err("Unable to set tcmu cmd_time_out while exports exist\n");
 		return -EINVAL;
 	}
 
@@ -2732,7 +2711,7 @@ static ssize_t tcmu_qfull_time_out_store(struct config_item *item,
 	} else if (val == -1) {
 		udev->qfull_time_out = val;
 	} else {
-		printk(KERN_ERR "Invalid qfull timeout value %d\n", val);
+		target_err("Invalid qfull timeout value %d\n", val);
 		return -EINVAL;
 	}
 	return count;
@@ -2817,7 +2796,7 @@ static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
 	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_dev_config_event(udev, page);
 		if (ret) {
-			pr_err("Unable to reconfigure device\n");
+			target_err("Unable to reconfigure device\n");
 			return ret;
 		}
 		strscpy(udev->dev_config, page, TCMU_CONFIG_LEN);
@@ -2879,7 +2858,7 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_dev_size_event(udev, val);
 		if (ret) {
-			pr_err("Unable to reconfigure device\n");
+			target_err("Unable to reconfigure device\n");
 			return ret;
 		}
 	}
@@ -2961,7 +2940,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_emulate_write_cache(udev, val);
 		if (ret) {
-			pr_err("Unable to reconfigure device\n");
+			target_err("Unable to reconfigure device\n");
 			return ret;
 		}
 	}
@@ -3028,7 +3007,7 @@ static ssize_t tcmu_block_dev_store(struct config_item *item, const char *page,
 	int ret;
 
 	if (!target_dev_configured(&udev->se_dev)) {
-		pr_err("Device is not configured.\n");
+		target_err("Device is not configured.\n");
 		return -EINVAL;
 	}
 
@@ -3037,7 +3016,7 @@ static ssize_t tcmu_block_dev_store(struct config_item *item, const char *page,
 		return ret;
 
 	if (val > 1) {
-		pr_err("Invalid block value %d\n", val);
+		target_err("Invalid block value %d\n", val);
 		return -EINVAL;
 	}
 
@@ -3060,7 +3039,7 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 	int ret;
 
 	if (!target_dev_configured(&udev->se_dev)) {
-		pr_err("Device is not configured.\n");
+		target_err("Device is not configured.\n");
 		return -EINVAL;
 	}
 
@@ -3069,7 +3048,7 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 		return ret;
 
 	if (val != 1 && val != 2) {
-		pr_err("Invalid reset ring value %d\n", val);
+		target_err("Invalid reset ring value %d\n", val);
 		return -EINVAL;
 	}
 
@@ -3090,7 +3069,7 @@ static ssize_t tcmu_free_kept_buf_store(struct config_item *item, const char *pa
 	int ret;
 
 	if (!target_dev_configured(&udev->se_dev)) {
-		pr_err("Device is not configured.\n");
+		target_err("Device is not configured.\n");
 		return -EINVAL;
 	}
 
@@ -3106,14 +3085,14 @@ static ssize_t tcmu_free_kept_buf_store(struct config_item *item, const char *pa
 		xas_lock(&xas);
 		cmd = xas_load(&xas);
 		if (!cmd) {
-			pr_err("free_kept_buf: cmd_id %d not found\n", cmd_id);
+			target_err("free_kept_buf: cmd_id %d not found\n", cmd_id);
 			count = -EINVAL;
 			xas_unlock(&xas);
 			goto out_unlock;
 		}
 		if (!test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
-			pr_err("free_kept_buf: cmd_id %d was not completed with KEEP_BUF\n",
-			       cmd_id);
+			target_err("free_kept_buf: cmd_id %d was not completed with KEEP_BUF\n",
+				   cmd_id);
 			count = -EINVAL;
 			xas_unlock(&xas);
 			goto out_unlock;
@@ -3250,9 +3229,9 @@ static void find_free_blocks(void)
 
 		total_pages_freed += pages_freed;
 		total_blocks_freed += end - start;
-		pr_debug("Freed %u pages (total %u) from %u blocks (total %u) from %s.\n",
-			 pages_freed, total_pages_freed, end - start,
-			 total_blocks_freed, udev->name);
+		target_debug("Freed %u pages (total %u) from %u blocks (total %u) from %s.\n",
+			     pages_freed, total_pages_freed, end - start, total_blocks_freed,
+			     udev->name);
 	}
 	mutex_unlock(&root_udev_mutex);
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 4128631c9dfd..30fd6d0f3e10 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -48,7 +48,7 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 	int rc;
 
 	if (!se_dev->dev_attrib.emulate_3pc) {
-		pr_debug("XCOPY: emulate_3pc disabled on se_dev %p\n", se_dev);
+		target_debug("XCOPY: emulate_3pc disabled on se_dev %p\n", se_dev);
 		return 0;
 	}
 
@@ -57,11 +57,11 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 
 	rc = memcmp(&tmp_dev_wwn[0], dev_wwn, XCOPY_NAA_IEEE_REGEX_LEN);
 	if (rc != 0) {
-		pr_debug("XCOPY: skip non-matching: %*ph\n",
-			 XCOPY_NAA_IEEE_REGEX_LEN, tmp_dev_wwn);
+		target_debug("XCOPY: skip non-matching: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN,
+			     tmp_dev_wwn);
 		return 0;
 	}
-	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
+	target_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
 
 	return 1;
 }
@@ -80,8 +80,7 @@ static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
 	if (!sess)
 		goto err_out;
 
-	pr_debug("XCOPY 0xe4: searching for: %*ph\n",
-		 XCOPY_NAA_IEEE_REGEX_LEN, dev_wwn);
+	target_debug("XCOPY 0xe4: searching for: %*ph\n", XCOPY_NAA_IEEE_REGEX_LEN, dev_wwn);
 
 	nacl = sess->se_node_acl;
 	rcu_read_lock();
@@ -103,13 +102,13 @@ static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
 	if (found_dev == NULL)
 		goto err_out;
 
-	pr_debug("lun_ref held for se_dev: %p se_dev->se_dev_group: %p\n",
-		 found_dev, &found_dev->dev_group);
+	target_debug("lun_ref held for se_dev: %p se_dev->se_dev_group: %p\n", found_dev,
+		     &found_dev->dev_group);
 	*_found_dev = found_dev;
 	*_found_lun_ref = &this_lun->lun_ref;
 	return 0;
 err_out:
-	pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
+	target_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
 	return -EINVAL;
 }
 
@@ -123,21 +122,20 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 * Extract RELATIVE INITIATOR PORT IDENTIFIER
 	 */
 	ript = get_unaligned_be16(&desc[2]);
-	pr_debug("XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %hu\n", ript);
+	target_debug("XCOPY 0xe4: RELATIVE INITIATOR PORT IDENTIFIER: %hu\n", ript);
 	/*
 	 * Check for supported code set, association, and designator type
 	 */
 	if ((desc[4] & 0x0f) != 0x1) {
-		pr_err("XCOPY 0xe4: code set of non binary type not supported\n");
+		target_err("XCOPY 0xe4: code set of non binary type not supported\n");
 		return -EINVAL;
 	}
 	if ((desc[5] & 0x30) != 0x00) {
-		pr_err("XCOPY 0xe4: association other than LUN not supported\n");
+		target_err("XCOPY 0xe4: association other than LUN not supported\n");
 		return -EINVAL;
 	}
 	if ((desc[5] & 0x0f) != 0x3) {
-		pr_err("XCOPY 0xe4: designator type unsupported: 0x%02x\n",
-				(desc[5] & 0x0f));
+		target_err("XCOPY 0xe4: designator type unsupported: 0x%02x\n", (desc[5] & 0x0f));
 		return -EINVAL;
 	}
 	/*
@@ -146,22 +144,22 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 */
 	desig_len = desc[7];
 	if (desig_len != XCOPY_NAA_IEEE_REGEX_LEN) {
-		pr_err("XCOPY 0xe4: invalid desig_len: %d\n", (int)desig_len);
+		target_err("XCOPY 0xe4: invalid desig_len: %d\n", (int)desig_len);
 		return -EINVAL;
 	}
-	pr_debug("XCOPY 0xe4: desig_len: %d\n", (int)desig_len);
+	target_debug("XCOPY 0xe4: desig_len: %d\n", (int)desig_len);
 	/*
 	 * Check for NAA IEEE Registered Extended Assigned header..
 	 */
 	if ((desc[8] & 0xf0) != 0x60) {
-		pr_err("XCOPY 0xe4: Unsupported DESIGNATOR TYPE: 0x%02x\n",
-					(desc[8] & 0xf0));
+		target_err("XCOPY 0xe4: Unsupported DESIGNATOR TYPE: 0x%02x\n", (desc[8] & 0xf0));
 		return -EINVAL;
 	}
 
 	if (cscd_index != xop->stdi && cscd_index != xop->dtdi) {
-		pr_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor "
-			 "dest\n", cscd_index);
+		target_debug("XCOPY 0xe4: ignoring CSCD entry %d - neither src nor "
+			     "dest\n",
+			     cscd_index);
 		return 0;
 	}
 
@@ -174,8 +172,9 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_SOURCE_RECV_OP;
 			xop->src_dev = se_cmd->se_dev;
-			pr_debug("XCOPY 0xe4: Set xop->src_dev %p from source"
-					" received xop\n", xop->src_dev);
+			target_debug("XCOPY 0xe4: Set xop->src_dev %p from source"
+				     " received xop\n",
+				     xop->src_dev);
 		}
 	}
 
@@ -191,8 +190,9 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 				XCOPY_NAA_IEEE_REGEX_LEN)) {
 			xop->op_origin = XCOL_DEST_RECV_OP;
 			xop->dst_dev = se_cmd->se_dev;
-			pr_debug("XCOPY 0xe4: Set xop->dst_dev: %p from destination"
-				" received xop\n", xop->dst_dev);
+			target_debug("XCOPY 0xe4: Set xop->dst_dev: %p from destination"
+				     " received xop\n",
+				     xop->dst_dev);
 		}
 	}
 
@@ -212,14 +212,16 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		pr_err("XCOPY target descriptor list length is not"
-			" multiple of %d\n", XCOPY_TARGET_DESC_LEN);
+		target_err("XCOPY target descriptor list length is not"
+			   " multiple of %d\n",
+			   XCOPY_TARGET_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (tdll > RCR_OP_MAX_TARGET_DESC_COUNT * XCOPY_TARGET_DESC_LEN) {
-		pr_err("XCOPY target descriptor supports a maximum"
-			" two src/dest descriptors, tdll: %hu too large..\n", tdll);
+		target_err("XCOPY target descriptor supports a maximum"
+			   " two src/dest descriptors, tdll: %hu too large..\n",
+			   tdll);
 		/* spc4r37 6.4.3.4 CSCD DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_TARGET_DESCS;
 		return -EINVAL;
@@ -248,8 +250,9 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 			cscd_index++;
 			break;
 		default:
-			pr_err("XCOPY unsupported descriptor type code:"
-					" 0x%02x\n", desc[0]);
+			target_err("XCOPY unsupported descriptor type code:"
+				   " 0x%02x\n",
+				   desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -269,8 +272,9 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 						&xop->remote_lun_ref);
 		break;
 	default:
-		pr_err("XCOPY CSCD descriptor IDs not found in CSCD list - "
-			"stdi: %hu dtdi: %hu\n", xop->stdi, xop->dtdi);
+		target_err("XCOPY CSCD descriptor IDs not found in CSCD list - "
+			   "stdi: %hu dtdi: %hu\n",
+			   xop->stdi, xop->dtdi);
 		rc = -EINVAL;
 		break;
 	}
@@ -285,10 +289,10 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 		goto out;
 	}
 
-	pr_debug("XCOPY TGT desc: Source dev: %p NAA IEEE WWN: 0x%16phN\n",
-		 xop->src_dev, &xop->src_tid_wwn[0]);
-	pr_debug("XCOPY TGT desc: Dest dev: %p NAA IEEE WWN: 0x%16phN\n",
-		 xop->dst_dev, &xop->dst_tid_wwn[0]);
+	target_debug("XCOPY TGT desc: Source dev: %p NAA IEEE WWN: 0x%16phN\n", xop->src_dev,
+		     &xop->src_tid_wwn[0]);
+	target_debug("XCOPY TGT desc: Dest dev: %p NAA IEEE WWN: 0x%16phN\n", xop->dst_dev,
+		     &xop->dst_tid_wwn[0]);
 
 	return cscd_index;
 
@@ -304,8 +308,9 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	desc_len = get_unaligned_be16(&desc[2]);
 	if (desc_len != 0x18) {
-		pr_err("XCOPY segment desc 0x02: Illegal desc_len:"
-				" %hu\n", desc_len);
+		target_err("XCOPY segment desc 0x02: Illegal desc_len:"
+			   " %hu\n",
+			   desc_len);
 		return -EINVAL;
 	}
 
@@ -314,20 +319,19 @@ static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 
 	if (xop->stdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX ||
 	    xop->dtdi > XCOPY_CSCD_DESC_ID_LIST_OFF_MAX) {
-		pr_err("XCOPY segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %hu dtdi: %hu\n",
-			XCOPY_CSCD_DESC_ID_LIST_OFF_MAX, xop->stdi, xop->dtdi);
+		target_err("XCOPY segment desc 0x02: unsupported CSCD ID > 0x%x; stdi: %hu dtdi: %hu\n",
+			   XCOPY_CSCD_DESC_ID_LIST_OFF_MAX, xop->stdi, xop->dtdi);
 		return -EINVAL;
 	}
 
-	pr_debug("XCOPY seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n",
-		desc_len, xop->stdi, xop->dtdi, dc);
+	target_debug("XCOPY seg desc 0x02: desc_len: %hu stdi: %hu dtdi: %hu, DC: %d\n", desc_len,
+		     xop->stdi, xop->dtdi, dc);
 
 	xop->nolb = get_unaligned_be16(&desc[10]);
 	xop->src_lba = get_unaligned_be64(&desc[12]);
 	xop->dst_lba = get_unaligned_be64(&desc[20]);
-	pr_debug("XCOPY seg desc 0x02: nolb: %hu src_lba: %llu dst_lba: %llu\n",
-		xop->nolb, (unsigned long long)xop->src_lba,
-		(unsigned long long)xop->dst_lba);
+	target_debug("XCOPY seg desc 0x02: nolb: %hu src_lba: %llu dst_lba: %llu\n", xop->nolb,
+		     (unsigned long long)xop->src_lba, (unsigned long long)xop->dst_lba);
 
 	return 0;
 }
@@ -343,14 +347,16 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 	*sense_ret = TCM_INVALID_PARAMETER_LIST;
 
 	if (offset != 0) {
-		pr_err("XCOPY segment descriptor list length is not"
-			" multiple of %d\n", XCOPY_SEGMENT_DESC_LEN);
+		target_err("XCOPY segment descriptor list length is not"
+			   " multiple of %d\n",
+			   XCOPY_SEGMENT_DESC_LEN);
 		*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 		return -EINVAL;
 	}
 	if (sdll > RCR_OP_MAX_SG_DESC_COUNT * XCOPY_SEGMENT_DESC_LEN) {
-		pr_err("XCOPY supports %u segment descriptor(s), sdll: %u too"
-			" large..\n", RCR_OP_MAX_SG_DESC_COUNT, sdll);
+		target_err("XCOPY supports %u segment descriptor(s), sdll: %u too"
+			   " large..\n",
+			   RCR_OP_MAX_SG_DESC_COUNT, sdll);
 		/* spc4r37 6.4.3.5 SEGMENT DESCRIPTOR LIST LENGTH field */
 		*sense_ret = TCM_TOO_MANY_SEGMENT_DESCS;
 		return -EINVAL;
@@ -371,8 +377,9 @@ static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
 			desc += XCOPY_SEGMENT_DESC_LEN;
 			break;
 		default:
-			pr_err("XCOPY unsupported segment descriptor"
-				"type: 0x%02x\n", desc[0]);
+			target_err("XCOPY unsupported segment descriptor"
+				   "type: 0x%02x\n",
+				   desc[0]);
 			*sense_ret = TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE;
 			goto out;
 		}
@@ -406,9 +413,9 @@ static int xcopy_pt_get_cmd_state(struct se_cmd *se_cmd)
 static void xcopy_pt_undepend_remotedev(struct xcopy_op *xop)
 {
 	if (xop->op_origin == XCOL_SOURCE_RECV_OP)
-		pr_debug("putting dst lun_ref for %p\n", xop->dst_dev);
+		target_debug("putting dst lun_ref for %p\n", xop->dst_dev);
 	else
-		pr_debug("putting src lun_ref for %p\n", xop->src_dev);
+		target_debug("putting src lun_ref for %p\n", xop->src_dev);
 
 	percpu_ref_put(xop->remote_lun_ref);
 }
@@ -419,7 +426,7 @@ static void xcopy_pt_release_cmd(struct se_cmd *se_cmd)
 				struct xcopy_pt_cmd, se_cmd);
 
 	/* xpt_cmd is on the stack, nothing to free here */
-	pr_debug("xpt_cmd done: %p\n", xpt_cmd);
+	target_debug("xpt_cmd done: %p\n", xpt_cmd);
 }
 
 static int xcopy_pt_check_stop_free(struct se_cmd *se_cmd)
@@ -464,7 +471,7 @@ int target_xcopy_setup_pt(void)
 {
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
-		pr_err("Unable to allocate xcopy_wq\n");
+		target_err("Unable to allocate xcopy_wq\n");
 		return -ENOMEM;
 	}
 
@@ -541,8 +548,9 @@ static int target_xcopy_setup_pt_cmd(
 					xop->xop_data_nents, NULL, 0))
 		return -EINVAL;
 
-	pr_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
-		 " %u\n", cmd->t_data_sg, cmd->t_data_nents);
+	target_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
+		     " %u\n",
+		     cmd->t_data_sg, cmd->t_data_nents);
 
 	return 0;
 }
@@ -561,8 +569,7 @@ static int target_xcopy_issue_pt_cmd(struct xcopy_pt_cmd *xpt_cmd)
 
 	wait_for_completion_interruptible(&xpt_cmd->xpt_passthrough_sem);
 
-	pr_debug("target_xcopy_issue_pt_cmd(): SCSI status: 0x%02x\n",
-			se_cmd->scsi_status);
+	target_debug("target_xcopy_issue_pt_cmd(): SCSI status: 0x%02x\n", se_cmd->scsi_status);
 
 	return (se_cmd->scsi_status) ? -EINVAL : 0;
 }
@@ -588,8 +595,8 @@ static int target_xcopy_read_source(
 	cdb[0] = READ_16;
 	put_unaligned_be64(src_lba, &cdb[2]);
 	put_unaligned_be32(transfer_length_block, &cdb[10]);
-	pr_debug("XCOPY: Built READ_16: LBA: %llu Blocks: %u Length: %u\n",
-		(unsigned long long)src_lba, transfer_length_block, src_bytes);
+	target_debug("XCOPY: Built READ_16: LBA: %llu Blocks: %u Length: %u\n",
+		     (unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
 			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
@@ -601,8 +608,9 @@ static int target_xcopy_read_source(
 		goto out;
 	}
 
-	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
-		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
+	target_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
+		     " memory\n",
+		     xop->xop_data_sg, xop->xop_data_nents);
 
 	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
 	if (rc < 0)
@@ -633,8 +641,8 @@ static int target_xcopy_write_destination(
 	cdb[0] = WRITE_16;
 	put_unaligned_be64(dst_lba, &cdb[2]);
 	put_unaligned_be32(transfer_length_block, &cdb[10]);
-	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Blocks: %u Length: %u\n",
-		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
+	target_debug("XCOPY: Built WRITE_16: LBA: %llu Blocks: %u Length: %u\n",
+		     (unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
 			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
@@ -699,10 +707,10 @@ static void target_xcopy_do_work(struct work_struct *work)
 	 */
 	max_blocks = max_bytes >> ilog2(src_dev->dev_attrib.block_size);
 
-	pr_debug("%s: nolb: %u, max_blocks: %llu end_lba: %llu\n", __func__,
-			nolb, max_blocks, (unsigned long long)end_lba);
-	pr_debug("%s: Starting src_lba: %llu, dst_lba: %llu\n", __func__,
-			(unsigned long long)src_lba, (unsigned long long)dst_lba);
+	target_debug("%s: nolb: %u, max_blocks: %llu end_lba: %llu\n", __func__, nolb, max_blocks,
+		     (unsigned long long)end_lba);
+	target_debug("%s: Starting src_lba: %llu, dst_lba: %llu\n", __func__,
+		     (unsigned long long)src_lba, (unsigned long long)dst_lba);
 
 	while (nolb) {
 		u32 cur_bytes = min_t(u64, max_bytes, nolb * src_dev->dev_attrib.block_size);
@@ -723,19 +731,19 @@ static void target_xcopy_do_work(struct work_struct *work)
 			xop->xop_data_bytes = cur_bytes;
 		}
 
-		pr_debug("%s: Calling read src_dev: %p src_lba: %llu, cur_nolb: %hu\n",
-				__func__, src_dev, (unsigned long long)src_lba, cur_nolb);
+		target_debug("%s: Calling read src_dev: %p src_lba: %llu, cur_nolb: %hu\n",
+			     __func__, src_dev, (unsigned long long)src_lba, cur_nolb);
 
 		rc = target_xcopy_read_source(ec_cmd, xop, src_dev, src_lba, cur_bytes);
 		if (rc < 0)
 			goto out;
 
 		src_lba += cur_bytes / src_dev->dev_attrib.block_size;
-		pr_debug("%s: Incremented READ src_lba to %llu\n", __func__,
-				(unsigned long long)src_lba);
+		target_debug("%s: Incremented READ src_lba to %llu\n", __func__,
+			     (unsigned long long)src_lba);
 
-		pr_debug("%s: Calling write dst_dev: %p dst_lba: %llu, cur_nolb: %u\n",
-				__func__, dst_dev, (unsigned long long)dst_lba, cur_nolb);
+		target_debug("%s: Calling write dst_dev: %p dst_lba: %llu, cur_nolb: %u\n",
+			     __func__, dst_dev, (unsigned long long)dst_lba, cur_nolb);
 
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
 						dst_lba, cur_bytes);
@@ -743,8 +751,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 			goto out;
 
 		dst_lba += cur_bytes / dst_dev->dev_attrib.block_size;
-		pr_debug("%s: Incremented WRITE dst_lba to %llu\n", __func__,
-				(unsigned long long)dst_lba);
+		target_debug("%s: Incremented WRITE dst_lba to %llu\n", __func__,
+			     (unsigned long long)dst_lba);
 
 		copied_bytes += cur_bytes;
 		nolb -= cur_bytes / src_dev->dev_attrib.block_size;
@@ -754,12 +762,12 @@ static void target_xcopy_do_work(struct work_struct *work)
 	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 	kfree(xop);
 
-	pr_debug("%s: Final src_lba: %llu, dst_lba: %llu\n", __func__,
-		(unsigned long long)src_lba, (unsigned long long)dst_lba);
-	pr_debug("%s: Blocks copied: %u, Bytes Copied: %u\n", __func__,
-		copied_bytes / dst_dev->dev_attrib.block_size, copied_bytes);
+	target_debug("%s: Final src_lba: %llu, dst_lba: %llu\n", __func__,
+		     (unsigned long long)src_lba, (unsigned long long)dst_lba);
+	target_debug("%s: Blocks copied: %u, Bytes Copied: %u\n", __func__,
+		     copied_bytes / dst_dev->dev_attrib.block_size, copied_bytes);
 
-	pr_debug("%s: Setting X-COPY GOOD status -> sending response\n", __func__);
+	target_debug("%s: Setting X-COPY GOOD status -> sending response\n", __func__);
 	target_complete_cmd(ec_cmd, SAM_STAT_GOOD);
 	return;
 
@@ -775,8 +783,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 err_free:
 	kfree(xop);
-	pr_warn_ratelimited("%s: rc: %d, sense: %u, XCOPY operation failed\n",
-			   __func__, rc, sense_rc);
+	target_warn_ratelimited("%s: rc: %d, sense: %u, XCOPY operation failed\n", __func__, rc,
+				sense_rc);
 	target_complete_cmd_with_sense(ec_cmd, SAM_STAT_CHECK_CONDITION, sense_rc);
 }
 
@@ -795,7 +803,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
-		pr_err("transport_kmap_data_sg() failed in target_do_xcopy\n");
+		target_err("transport_kmap_data_sg() failed in target_do_xcopy\n");
 		return TCM_OUT_OF_RESOURCES;
 	}
 
@@ -808,29 +816,29 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	tdll = get_unaligned_be16(&p[2]);
 	sdll = get_unaligned_be32(&p[8]);
 	if (tdll + sdll > RCR_OP_MAX_DESC_LIST_LEN) {
-		pr_err("XCOPY descriptor list length %u exceeds maximum %u\n",
-		       tdll + sdll, RCR_OP_MAX_DESC_LIST_LEN);
+		target_err("XCOPY descriptor list length %u exceeds maximum %u\n", tdll + sdll,
+			   RCR_OP_MAX_DESC_LIST_LEN);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
 
 	inline_dl = get_unaligned_be32(&p[12]);
 	if (inline_dl != 0) {
-		pr_err("XCOPY with non zero inline data length\n");
+		target_err("XCOPY with non zero inline data length\n");
 		goto out;
 	}
 
 	if (se_cmd->data_length < (XCOPY_HDR_LEN + tdll + sdll + inline_dl)) {
-		pr_err("XCOPY parameter truncation: data length %u too small "
-			"for tdll: %hu sdll: %u inline_dl: %u\n",
-			se_cmd->data_length, tdll, sdll, inline_dl);
+		target_err("XCOPY parameter truncation: data length %u too small "
+			   "for tdll: %hu sdll: %u inline_dl: %u\n",
+			   se_cmd->data_length, tdll, sdll, inline_dl);
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
 
-	pr_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x"
-		" tdll: %hu sdll: %u inline_dl: %u\n", list_id, list_id_usage,
-		tdll, sdll, inline_dl);
+	target_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x"
+		     " tdll: %hu sdll: %u inline_dl: %u\n",
+		     list_id, list_id_usage, tdll, sdll, inline_dl);
 
 	/*
 	 * skip over the target descriptors until segment descriptors
@@ -842,8 +850,8 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	if (rc <= 0)
 		goto out;
 
-	pr_debug("XCOPY: Processed %d segment descriptors, length: %u\n", rc,
-				rc * XCOPY_SEGMENT_DESC_LEN);
+	target_debug("XCOPY: Processed %d segment descriptors, length: %u\n", rc,
+		     rc * XCOPY_SEGMENT_DESC_LEN);
 
 	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll, &ret);
 	if (rc <= 0)
@@ -851,17 +859,17 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 
 	if (xop->src_dev->dev_attrib.block_size !=
 	    xop->dst_dev->dev_attrib.block_size) {
-		pr_err("XCOPY: Non matching src_dev block_size: %u + dst_dev"
-		       " block_size: %u currently unsupported\n",
-			xop->src_dev->dev_attrib.block_size,
-			xop->dst_dev->dev_attrib.block_size);
+		target_err("XCOPY: Non matching src_dev block_size: %u + dst_dev"
+			   " block_size: %u currently unsupported\n",
+			   xop->src_dev->dev_attrib.block_size,
+			   xop->dst_dev->dev_attrib.block_size);
 		xcopy_pt_undepend_remotedev(xop);
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
 	}
 
-	pr_debug("XCOPY: Processed %d target descriptors, length: %u\n", rc,
-				rc * XCOPY_TARGET_DESC_LEN);
+	target_debug("XCOPY: Processed %d target descriptors, length: %u\n", rc,
+		     rc * XCOPY_TARGET_DESC_LEN);
 	transport_kunmap_data_sg(se_cmd);
 	return TCM_NO_SENSE;
 
@@ -878,13 +886,13 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	unsigned int sa;
 
 	if (!dev->dev_attrib.emulate_3pc) {
-		pr_err("EXTENDED_COPY operation explicitly disabled\n");
+		target_err("EXTENDED_COPY operation explicitly disabled\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	sa = se_cmd->t_task_cdb[1] & 0x1f;
 	if (sa != 0x00) {
-		pr_err("EXTENDED_COPY(LID4) not supported\n");
+		target_err("EXTENDED_COPY(LID4) not supported\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -893,8 +901,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		return TCM_NO_SENSE;
 	}
 	if (se_cmd->data_length < XCOPY_HDR_LEN) {
-		pr_err("XCOPY parameter truncation: length %u < hdr_len %u\n",
-				se_cmd->data_length, XCOPY_HDR_LEN);
+		target_err("XCOPY parameter truncation: length %u < hdr_len %u\n",
+			   se_cmd->data_length, XCOPY_HDR_LEN);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -920,14 +928,15 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
-		pr_err("transport_kmap_data_sg failed in"
-		       " target_rcr_operating_parameters\n");
+		target_err("transport_kmap_data_sg failed in"
+			   " target_rcr_operating_parameters\n");
 		return TCM_OUT_OF_RESOURCES;
 	}
 
 	if (se_cmd->data_length < 54) {
-		pr_err("Receive Copy Results Op Parameters length"
-		       " too small: %u\n", se_cmd->data_length);
+		target_err("Receive Copy Results Op Parameters length"
+			   " too small: %u\n",
+			   se_cmd->data_length);
 		transport_kunmap_data_sg(se_cmd);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -1012,16 +1021,17 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 	sense_reason_t rc = TCM_NO_SENSE;
 
 	if (!dev->dev_attrib.emulate_3pc) {
-		pr_debug("Third-party copy operations explicitly disabled\n");
+		target_debug("Third-party copy operations explicitly disabled\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
-	pr_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID:"
-		" 0x%02x, AL: %u\n", sa, list_id, se_cmd->data_length);
+	target_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID:"
+		     " 0x%02x, AL: %u\n",
+		     sa, list_id, se_cmd->data_length);
 
 	if (list_id != 0) {
-		pr_err("Receive Copy Results with non zero list identifier"
-		       " not supported\n");
+		target_err("Receive Copy Results with non zero list identifier"
+			   " not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -1033,7 +1043,7 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 	case RCR_SA_RECEIVE_DATA:
 	case RCR_SA_FAILED_SEGMENT_DETAILS:
 	default:
-		pr_err("Unsupported SA for receive copy results: 0x%02x\n", sa);
+		target_err("Unsupported SA for receive copy results: 0x%02x\n", sa);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 21783cd71c15..9ab560d9f520 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -37,26 +37,24 @@ static void _ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	int count;
 
 	se_cmd = &cmd->se_cmd;
-	pr_debug("%s: cmd %p sess %p seq %p se_cmd %p\n",
-		caller, cmd, cmd->sess, cmd->seq, se_cmd);
+	target_debug("%s: cmd %p sess %p seq %p se_cmd %p\n", caller, cmd, cmd->sess, cmd->seq,
+		     se_cmd);
 
-	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
-		caller, cmd, se_cmd->t_data_nents,
-	       se_cmd->data_length, se_cmd->se_cmd_flags);
+	target_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n", caller, cmd,
+		     se_cmd->t_data_nents, se_cmd->data_length, se_cmd->se_cmd_flags);
 
 	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, count)
-		pr_debug("%s: cmd %p sg %p page %p "
-			"len 0x%x off 0x%x\n",
-			caller, cmd, sg,
-			sg_page(sg), sg->length, sg->offset);
+		target_debug("%s: cmd %p sg %p page %p "
+			     "len 0x%x off 0x%x\n",
+			     caller, cmd, sg, sg_page(sg), sg->length, sg->offset);
 
 	sp = cmd->seq;
 	if (sp) {
 		ep = fc_seq_exch(sp);
-		pr_debug("%s: cmd %p sid %x did %x "
-			"ox_id %x rx_id %x seq_id %x e_stat %x\n",
-			caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid,
-			sp->id, ep->esb_stat);
+		target_debug("%s: cmd %p sid %x did %x "
+			     "ox_id %x rx_id %x seq_id %x e_stat %x\n",
+			     caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid, sp->id,
+			     ep->esb_stat);
 	}
 }
 
@@ -151,8 +149,9 @@ int ft_queue_status(struct se_cmd *se_cmd)
 
 	rc = fc_seq_send(lport, cmd->seq, fp);
 	if (rc) {
-		pr_info_ratelimited("%s: Failed to send response frame %p, "
-				    "xid <0x%x>\n", __func__, fp, ep->xid);
+		target_info_ratelimited("%s: Failed to send response frame %p, "
+					"xid <0x%x>\n",
+					__func__, fp, ep->xid);
 		/*
 		 * Generate a TASK_SET_FULL status to notify the initiator
 		 * to reduce it's queue_depth after the se_cmd response has
@@ -248,8 +247,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	case FC_RCTL_DD_SOL_CTL:	/* transfer ready */
 	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
 	default:
-		pr_debug("%s: unhandled frame r_ctl %x\n",
-		       __func__, fh->fh_r_ctl);
+		target_debug("%s: unhandled frame r_ctl %x\n", __func__, fh->fh_r_ctl);
 		ft_invl_hw_context(cmd);
 		fc_frame_free(fp);
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -274,8 +272,8 @@ static void ft_send_resp_status(struct fc_lport *lport,
 	struct fcp_resp_rsp_info *info;
 
 	fh = fc_frame_header_get(rx_fp);
-	pr_debug("FCP error response: did %x oxid %x status %x code %x\n",
-		  ntoh24(fh->fh_s_id), ntohs(fh->fh_ox_id), status, code);
+	target_debug("FCP error response: did %x oxid %x status %x code %x\n", ntoh24(fh->fh_s_id),
+		     ntohs(fh->fh_ox_id), status, code);
 	len = sizeof(*fcp);
 	if (status == SAM_STAT_GOOD)
 		len += sizeof(*info);
@@ -356,7 +354,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		 * FCP4r01 indicates having a combination of
 		 * tm_flags set is invalid.
 		 */
-		pr_debug("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
+		target_debug("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
 		ft_send_resp_code_and_free(cmd, FCP_CMND_FIELDS_INVALID);
 		return;
 	}
@@ -396,8 +394,7 @@ void ft_queue_tm_resp(struct se_cmd *se_cmd)
 		code = FCP_TMF_FAILED;
 		break;
 	}
-	pr_debug("tmr fn %d resp %d fcp code %d\n",
-		  tmr->function, tmr->response, code);
+	target_debug("tmr fn %d resp %d fcp code %d\n", tmr->function, tmr->response, code);
 	ft_send_resp_code(cmd, code);
 	/*
 	 * Drop the extra ACK_KREF reference taken by target_submit_tmr()
@@ -446,7 +443,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	return;
 
 busy:
-	pr_debug("cmd or seq allocation failure - sending BUSY\n");
+	target_debug("cmd or seq allocation failure - sending BUSY\n");
 	ft_send_resp_status(lport, fp, SAM_STAT_BUSY, 0);
 	fc_frame_free(fp);
 	ft_sess_put(sess);		/* undo get from lookup */
@@ -471,8 +468,7 @@ void ft_recv_req(struct ft_sess *sess, struct fc_frame *fp)
 	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
 	case FC_RCTL_ELS4_REQ:		/* SRR, perhaps */
 	default:
-		pr_debug("%s: unhandled frame r_ctl %x\n",
-		       __func__, fh->fh_r_ctl);
+		target_debug("%s: unhandled frame r_ctl %x\n", __func__, fh->fh_r_ctl);
 		fc_frame_free(fp);
 		ft_sess_put(sess);	/* undo get from lookup */
 		break;
@@ -554,7 +550,7 @@ static void ft_send_work(struct work_struct *work)
 		return;
 
 	target_submit(&cmd->se_cmd);
-	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
+	target_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
 	return;
 
 err:
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 5ee03d1cba2b..df2414b8c0cd 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -81,8 +81,7 @@ static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
 	}
 	err = 4;
 fail:
-	pr_debug("err %u len %zu pos %u byte %u\n",
-		    err, cp - name, pos, byte);
+	target_debug("err %u len %zu pos %u byte %u\n", err, cp - name, pos, byte);
 	return -1;
 }
 
@@ -223,7 +222,7 @@ static struct se_portal_group *ft_add_tpg(struct se_wwn *wwn, const char *name)
 	unsigned long index;
 	int ret;
 
-	pr_debug("tcm_fc: add tpg %s\n", name);
+	target_debug("tcm_fc: add tpg %s\n", name);
 
 	/*
 	 * Name must be "tpgt_" followed by the index.
@@ -238,7 +237,7 @@ static struct se_portal_group *ft_add_tpg(struct se_wwn *wwn, const char *name)
 		return NULL;
 
 	if ((index != 1)) {
-		pr_err("Error, a single TPG=1 is used for HW port mappings\n");
+		target_err("Error, a single TPG=1 is used for HW port mappings\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -276,8 +275,7 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 	struct ft_lport_wwn *ft_wwn = tpg->lport_wwn;
 
-	pr_debug("del tpg %s\n",
-		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
+	target_debug("del tpg %s\n", config_item_name(&tpg->se_tpg.tpg_group.cg_item));
 
 	destroy_workqueue(tpg->workqueue);
 
@@ -330,7 +328,7 @@ static struct se_wwn *ft_add_wwn(
 	struct ft_lport_wwn *old_ft_wwn;
 	u64 wwpn;
 
-	pr_debug("add wwn %s\n", name);
+	target_debug("add wwn %s\n", name);
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
 		return NULL;
 	ft_wwn = kzalloc(sizeof(*ft_wwn), GFP_KERNEL);
@@ -358,7 +356,7 @@ static void ft_del_wwn(struct se_wwn *wwn)
 	struct ft_lport_wwn *ft_wwn = container_of(wwn,
 				struct ft_lport_wwn, se_wwn);
 
-	pr_debug("del wwn %s\n", ft_wwn->name);
+	target_debug("del wwn %s\n", ft_wwn->name);
 	mutex_lock(&ft_lport_lock);
 	list_del(&ft_wwn->ft_wwn_node);
 	mutex_unlock(&ft_lport_lock);
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index bbe2e29612fa..cc772793149e 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -91,8 +91,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 		struct fc_seq *seq = cmd->seq;
 
 		if (!seq) {
-			pr_debug("%s: Command aborted, xid 0x%x\n",
-				 __func__, ep->xid);
+			target_debug("%s: Command aborted, xid 0x%x\n", __func__, ep->xid);
 			break;
 		}
 		if (!mem_len) {
@@ -162,11 +161,10 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			       FC_TYPE_FCP, f_ctl, fh_off);
 		error = fc_seq_send(lport, seq, fp);
 		if (error) {
-			pr_info_ratelimited("%s: Failed to send frame %p, "
+			target_info_ratelimited("%s: Failed to send frame %p, "
 						"xid <0x%x>, remaining %zu, "
 						"lso_max <0x%x>\n",
-						__func__, fp, ep->xid,
-						remaining, lport->lso_max);
+						__func__, fp, ep->xid, remaining, lport->lso_max);
 			/*
 			 * Go ahead and set TASK_SET_FULL status ignoring the
 			 * rest of the DataIN, and immediately attempt to
@@ -227,13 +225,14 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		 */
 		buf = fc_frame_payload_get(fp, 1);
 		if (buf)
-			pr_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, "
-				"cmd->sg_cnt 0x%x. DDP was setup"
-				" hence not expected to receive frame with "
-				"payload, Frame will be dropped if"
-				"'Sequence Initiative' bit in f_ctl is"
-				"not set\n", __func__, ep->xid, f_ctl,
-				se_cmd->t_data_sg, se_cmd->t_data_nents);
+			target_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, "
+				   "cmd->sg_cnt 0x%x. DDP was setup"
+				   " hence not expected to receive frame with "
+				   "payload, Frame will be dropped if"
+				   "'Sequence Initiative' bit in f_ctl is"
+				   "not set\n",
+				   __func__, ep->xid, f_ctl, se_cmd->t_data_sg,
+				   se_cmd->t_data_nents);
 		/*
 		 * Invalidate HW DDP context if it was setup for respective
 		 * command. Invalidation of HW DDP context is requited in both
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 593540da9346..e69b6211886e 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -28,9 +28,7 @@
 #include "tcm_fc.h"
 
 #define TFC_SESS_DBG(lport, fmt, args...) \
-	pr_debug("host%u: rport %6.6x: " fmt,	   \
-		 (lport)->host->host_no,	   \
-		 (lport)->port_id, ##args )
+	target_debug("host%u: rport %6.6x: " fmt, (lport)->host->host_no, (lport)->port_id, ##args)
 
 static void ft_sess_delete_all(struct ft_tport *);
 
diff --git a/drivers/target/tcm_remote/tcm_remote.c b/drivers/target/tcm_remote/tcm_remote.c
index cb8db2558056..fe88c27f1b58 100644
--- a/drivers/target/tcm_remote/tcm_remote.c
+++ b/drivers/target/tcm_remote/tcm_remote.c
@@ -71,8 +71,7 @@ static int tcm_remote_port_link(
 	struct se_portal_group *se_tpg,
 	struct se_lun *lun)
 {
-	pr_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n",
-		 lun->unpacked_lun);
+	target_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n", lun->unpacked_lun);
 	return 0;
 }
 
@@ -80,8 +79,7 @@ static void tcm_remote_port_unlink(
 	struct se_portal_group *se_tpg,
 	struct se_lun *lun)
 {
-	pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
-		 lun->unpacked_lun);
+	target_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n", lun->unpacked_lun);
 }
 
 static struct se_portal_group *tcm_remote_make_tpg(
@@ -95,15 +93,14 @@ static struct se_portal_group *tcm_remote_make_tpg(
 	int ret;
 
 	if (strstr(name, "tpgt_") != name) {
-		pr_err("Unable to locate \"tpgt_#\" directory group\n");
+		target_err("Unable to locate \"tpgt_#\" directory group\n");
 		return ERR_PTR(-EINVAL);
 	}
 	if (kstrtoul(name + 5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tpgt >= TL_TPGS_PER_HBA) {
-		pr_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n",
-		       tpgt, TL_TPGS_PER_HBA);
+		target_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
 	}
 	remote_tpg = &remote_hba->remote_hba_tpgs[tpgt];
@@ -117,9 +114,9 @@ static struct se_portal_group *tcm_remote_make_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	pr_debug("TCM_Remote_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
-		 tcm_remote_dump_proto_id(remote_hba),
-		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	target_debug("TCM_Remote_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
+		     tcm_remote_dump_proto_id(remote_hba),
+		     config_item_name(&wwn->wwn_group.cg_item), tpgt);
 	return &remote_tpg->remote_se_tpg;
 }
 
@@ -142,9 +139,9 @@ static void tcm_remote_drop_tpg(struct se_portal_group *se_tpg)
 	remote_tpg->remote_hba = NULL;
 	remote_tpg->remote_tpgt = 0;
 
-	pr_debug("TCM_Remote_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
-		 tcm_remote_dump_proto_id(remote_hba),
-		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	target_debug("TCM_Remote_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
+		     tcm_remote_dump_proto_id(remote_hba),
+		     config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
 
 static struct se_wwn *tcm_remote_make_wwn(
@@ -183,8 +180,7 @@ static struct se_wwn *tcm_remote_make_wwn(
 	}
 	ptr = strstr(name, "iqn.");
 	if (!ptr) {
-		pr_err("Unable to locate prefix for emulated Target Port: %s\n",
-		       name);
+		target_err("Unable to locate prefix for emulated Target Port: %s\n", name);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -192,15 +188,15 @@ static struct se_wwn *tcm_remote_make_wwn(
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA %s Address: %s, exceeds max: %d\n",
-		       name, tcm_remote_dump_proto_id(remote_hba), TL_WWN_ADDR_LEN);
+		target_err("Emulated NAA %s Address: %s, exceeds max: %d\n", name,
+			   tcm_remote_dump_proto_id(remote_hba), TL_WWN_ADDR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
 	snprintf(&remote_hba->remote_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
-	pr_debug("TCM_Remote_ConfigFS: Allocated emulated Target %s Address: %s\n",
-		 tcm_remote_dump_proto_id(remote_hba), name);
+	target_debug("TCM_Remote_ConfigFS: Allocated emulated Target %s Address: %s\n",
+		     tcm_remote_dump_proto_id(remote_hba), name);
 	return &remote_hba->remote_hba_wwn;
 out:
 	kfree(remote_hba);
@@ -212,9 +208,8 @@ static void tcm_remote_drop_wwn(struct se_wwn *wwn)
 	struct tcm_remote_hba *remote_hba = container_of(wwn,
 				struct tcm_remote_hba, remote_hba_wwn);
 
-	pr_debug("TCM_Remote_ConfigFS: Deallocating emulated Target %s Address: %s\n",
-		 tcm_remote_dump_proto_id(remote_hba),
-		 remote_hba->remote_wwn_address);
+	target_debug("TCM_Remote_ConfigFS: Deallocating emulated Target %s Address: %s\n",
+		     tcm_remote_dump_proto_id(remote_hba), remote_hba->remote_wwn_address);
 	kfree(remote_hba);
 }
 
-- 
2.40.3

