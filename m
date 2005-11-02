From: Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH/RFC v2] IB: Add SCSI RDMA Protocol
	(SRP) initiator
Date: Wed, 02 Nov 2005 14:08:35 -0800
Message-ID: <52irva8zz0.fsf@cisco.com>
References: <52r79y91jz.fsf_-_@cisco.com>
	<20051102220358.GA27132@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <openib-general-bounces@openib.org>
In-Reply-To: <20051102220358.GA27132@mellanox.co.il> (Michael S. Tsirkin's
	message of "Thu, 3 Nov 2005 00:03:58 +0200")
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

OK, I replaced the function with:

+static int srp_init_qp(struct srp_target_port *target,
+		       struct ib_qp *qp)
+{
+	struct ib_qp_attr *attr;
+	int ret;
+
+	attr = kmalloc(sizeof *attr, GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	ret = ib_find_cached_pkey(target->srp_host->dev,
+				  target->srp_host->port,
+				  be16_to_cpu(target->path.pkey),
+				  &attr->pkey_index);
+	if (ret)
+		goto out;
+
+	attr->qp_state        = IB_QPS_INIT;
+	attr->qp_access_flags = (IB_ACCESS_REMOTE_READ |
+				    IB_ACCESS_REMOTE_WRITE);
+	attr->port_num        = target->srp_host->port;
+
+	ret = ib_modify_qp(qp, attr,
+			   IB_QP_STATE		|
+			   IB_QP_PKEY_INDEX	|
+			   IB_QP_ACCESS_FLAGS	|
+			   IB_QP_PORT);
+
+out:
+	kfree(attr);
+	return ret;
+}
