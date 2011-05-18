From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC v2 PATCH 2/2] scsi_transport_fc: Add additional rport
 attributes.
Date: Wed, 18 May 2011 14:48:32 -0400
Message-ID: <alpine.LFD.2.02.1105181447180.7238@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:50334
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933485Ab1ERSsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 14:48:42 -0400
Received: from mail97-ch1 (localhost.localdomain [127.0.0.1])	by
 mail97-ch1-R.bigfish.com (Postfix) with ESMTP id 45634175038F	for
 <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:48:41 +0000 (UTC)
Received: from CH1EHSMHS012.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.252])	by mail97-ch1.bigfish.com (Postfix) with ESMTP id C0040A4804F
	for <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:48:39 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

This patch adds the following new fc_remote_port sysfs attributes:

- supported_fc4s
- supported_speeds
- speed
- active_fc4s
- port_type
- symbolic_name
- fabric_name

The attributes are populated by sending CT commands via the bsg in-kernel
interface.  A new function, fc_bsg_ct_cmd_execute(), has been added to
populate the sg_io_v4 interface and to send the request to the bsg layer.
Two functions, one for the name server, fc_bsg_ct_ns_cmd(), and one for the
fabric management server, fc_bsg_ct_ms_cmd(), have been created to send the
CT commands to the correct generic service and to populate the right rport
attribute based on the command type.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
  drivers/scsi/scsi_transport_fc.c |  379 +++++++++++++++++++++++++++++++++++++-
  include/scsi/fc/fc_ns.h          |   26 +++
  include/scsi/fc_encode.h         |    1 +
  include/scsi/scsi_transport_fc.h |   27 +++-
  4 files changed, 427 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 815069d..8af04ea 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -39,6 +39,11 @@
  #include <net/netlink.h>
  #include <scsi/scsi_netlink_fc.h>
  #include <scsi/scsi_bsg_fc.h>
+#include <scsi/fc/fc_gs.h>
+#include <scsi/fc/fc_ns.h>
+#include <scsi/fc/fc_els.h>
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
  #include "scsi_priv.h"
  #include "scsi_transport_fc_internal.h"

@@ -52,6 +57,12 @@ static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
  static void fc_bsg_remove(struct request_queue *);
  static void fc_bsg_goose_queue(struct fc_rport *);

+static int fc_bsg_ct_cmd_execute(struct fc_rport *, uint8_t, uint16_t,
+                                struct fc_ct_req *, void *, int);
+static int fc_bsg_ct_ns_cmd(struct fc_rport *, uint16_t);
+static int fc_bsg_ct_ms_cmd(struct fc_rport *, uint16_t);
+static uint32_t fc_parse_gpsc_rsp(uint16_t);
+
  /*
   * Module Parameters
   */
@@ -311,7 +322,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
   * Increase these values if you add attributes
   */
  #define FC_STARGET_NUM_ATTRS  3
-#define FC_RPORT_NUM_ATTRS     10
+#define FC_RPORT_NUM_ATTRS     17
  #define FC_VPORT_NUM_ATTRS    9
  #define FC_HOST_NUM_ATTRS     22

@@ -826,6 +837,57 @@ show_fc_rport_supported_classes (struct device *dev,
  static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
                show_fc_rport_supported_classes, NULL);

+static ssize_t
+show_fc_rport_supported_fc4s(struct device *dev,
+                            struct device_attribute *attr, char *buf)
+{
+       struct fc_rport *rport = transport_class_to_rport(dev);
+       return (ssize_t)show_fc_fc4s(buf, rport->supported_fc4s);
+}
+static FC_DEVICE_ATTR(rport, supported_fc4s, S_IRUGO,
+               show_fc_rport_supported_fc4s, NULL);
+
+static ssize_t
+show_fc_rport_supported_speeds(struct device *dev,
+                              struct device_attribute *attr, char *buf)
+{
+       struct fc_rport *rport = transport_class_to_rport(dev);
+
+       if (rport->supported_speeds  == FC_PORTSPEED_UNKNOWN)
+               return snprintf(buf, 20, "unknown\n");
+
+       return get_fc_port_speed_names(rport->supported_speeds, buf);
+}
+static FC_DEVICE_ATTR(rport, supported_speeds, S_IRUGO,
+               show_fc_rport_supported_speeds, NULL);
+
+static ssize_t
+show_fc_rport_speed(struct device *dev, struct device_attribute *attr,
+                   char *buf)
+{
+       struct fc_rport *rport = transport_class_to_rport(dev);
+
+       if (rport->speed == FC_PORTSPEED_UNKNOWN)
+               return snprintf(buf, 20, "unknown\n");
+
+       return get_fc_port_speed_names(rport->speed, buf);
+}
+static FC_DEVICE_ATTR(rport, speed, S_IRUGO, show_fc_rport_speed, NULL);
+
+static ssize_t
+show_fc_rport_active_fc4s(struct device *dev, struct device_attribute *attr,
+                         char *buf)
+{
+       struct fc_rport *rport = transport_class_to_rport(dev);
+       return (ssize_t)show_fc_fc4s(buf, rport->active_fc4s);
+}
+static FC_DEVICE_ATTR(rport, active_fc4s, S_IRUGO, show_fc_rport_active_fc4s,
+               NULL);
+
+fc_private_rport_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
+fc_private_rport_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE);
+fc_private_rport_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
+
  /* Dynamic Remote Port Attributes */

  /*
@@ -2239,6 +2301,13 @@ fc_attach_transport(struct fc_function_template *ft)
        count=0;
        SETUP_RPORT_ATTRIBUTE_RD(maxframe_size);
        SETUP_RPORT_ATTRIBUTE_RD(supported_classes);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(supported_fc4s);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(supported_speeds);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(speed);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(active_fc4s);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_type);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(symbolic_name);
+       SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(fabric_name);
        SETUP_RPORT_ATTRIBUTE_RW(dev_loss_tmo);
        SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(node_name);
        SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
@@ -2581,6 +2650,13 @@ fc_rport_create(struct Scsi_Host *shost, int channel,

        rport->maxframe_size = -1;
        rport->supported_classes = FC_COS_UNSPECIFIED;
+       memset(rport->supported_fc4s, 0, sizeof(rport->supported_fc4s));
+       rport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+       rport->port_type = FC_PORTTYPE_UNKNOWN;
+       rport->speed = FC_PORTSPEED_UNKNOWN;
+       memset(rport->active_fc4s, 0, sizeof(rport->active_fc4s));
+       memset(rport->symbolic_name, 0, sizeof(rport->symbolic_name));
+       rport->fabric_name = -1;
        rport->dev_loss_tmo = fc_host->dev_loss_tmo;
        memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
        memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
@@ -3062,6 +3138,13 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
                spin_unlock_irqrestore(shost->host_lock, flags);
                scsi_target_unblock(&rport->dev);
        }
+
+       /* CT queries for some rport attributes */
+       fc_bsg_ct_ns_cmd(rport, FC_NS_GFPN_ID);
+       fc_bsg_ct_ns_cmd(rport, FC_NS_GFT_ID);
+       fc_bsg_ct_ns_cmd(rport, FS_NS_GPT_ID);
+       fc_bsg_ct_ns_cmd(rport, FC_NS_GSPN_ID);
+       fc_bsg_ct_ms_cmd(rport, 0x127);
  }
  EXPORT_SYMBOL(fc_remote_port_rolechg);

@@ -4142,6 +4225,300 @@ fc_bsg_remove(struct request_queue *q)
        }
  }

+static int
+fc_bsg_ct_cmd_execute(struct fc_rport *rport, uint8_t gs_type, uint16_t ct_cmd,
+                     struct fc_ct_req *ct_req, void *ct_resp, int size)
+{
+       struct Scsi_Host *shost = rport_to_shost(rport);
+       struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+       struct sg_io_v4 *hdr;
+       struct fc_bsg_request *cdb;
+       int ret;
+       int transfer_size = size >> 2; /* max/residual size in 32 bit workds */
+       int resp_size = sizeof(struct fc_bsg_reply) + 12;
+       uint8_t resp[resp_size];
+       uint8_t gs_subtype;
+
+       /* Make sure we have a valid bsg request queue */
+       if (!fc_host->rqst_q)
+               return -ENXIO;
+
+       if (gs_type == FC_FST_DIR)
+               gs_subtype = FC_NS_SUBTYPE;
+       else if (gs_type == FC_FST_MGMT)
+               gs_subtype = 0x1;
+       else
+               return -EINVAL;
+
+       /* Fill in common parts of ct header */
+       ct_req->hdr.ct_rev = FC_CT_REV;
+       ct_req->hdr.ct_fs_type = gs_type;
+       ct_req->hdr.ct_fs_subtype = gs_subtype;
+       ct_req->hdr.ct_cmd = __cpu_to_be16(ct_cmd);
+       ct_req->hdr.ct_mr_size = __cpu_to_be16(size >> 2);
+
+       cdb = kzalloc(sizeof(struct fc_bsg_request), GFP_KERNEL);
+       if (!cdb){
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       cdb->msgcode = FC_BSG_HST_CT;
+       cdb->rqst_data.h_ct.preamble_word2 = (ct_cmd << 16) | transfer_size;
+       cdb->rqst_data.h_ct.preamble_word1 = (gs_type << 24) | (gs_subtype << 16);
+       cdb->rqst_data.h_ct.preamble_word0 = 0x01000000;
+       cdb->rqst_data.h_ct.port_id[0] = gs_type;
+       cdb->rqst_data.h_ct.port_id[1] = 0xff;
+       cdb->rqst_data.h_ct.port_id[2] = 0xff;
+
+       hdr = kzalloc(sizeof(struct sg_io_v4), GFP_KERNEL);
+       if (!hdr) {
+               ret = -ENOMEM;
+               goto cdb_out;
+       }
+
+       hdr->guard = 'Q';
+       hdr->protocol = BSG_PROTOCOL_SCSI;
+       hdr->subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;
+       hdr->request_len = sizeof(struct fc_bsg_request);
+       hdr->request = (__u64)cdb;
+       hdr->din_xfer_len = resp_size;
+       hdr->din_xferp = (__u64)ct_resp;
+
+       hdr->dout_xfer_len = sizeof(struct fc_ct_req);
+       hdr->dout_xferp = (__u64)ct_req;
+       hdr->max_response_len = sizeof(resp);
+       hdr->response = (__u64)resp;
+
+       ret = bsg_private_command(fc_host->rqst_q, hdr);
+
+       kfree(hdr);
+cdb_out:
+       kfree(cdb);
+out:
+       return ret;
+}
+
+static void fc_bsg_ct_assign_fid(struct fc_ct_req *ct_req,
+                                struct fc_rport *rport)
+{
+       /*
+        * Set the fabric ID for commands that is to address the port we're
+        * looking for.
+        */
+       ct_req->payload.fid.fp_fid[2] = rport->port_id & 0xFF;
+       ct_req->payload.fid.fp_fid[1] = (rport->port_id & 0xFF00) >> 8;
+       ct_req->payload.fid.fp_fid[0] = (rport->port_id & 0xFF0000) >> 16;
+}
+
+static int fc_bsg_ct_check_rsp(void *ct_resp)
+{
+       struct fc_ct_hdr *ct_hdr = ct_resp;
+       return (ntohs(ct_hdr->ct_cmd) == FC_FS_ACC);
+}
+
+#define GSPC_VAL_SIZE           5
+static const struct {
+       uint16_t gpsc_bit;
+       uint32_t fc_speed_bit;
+} gpsc_val[] = {
+       {0x8000, FC_PORTSPEED_1GBIT},
+       {0x4000, FC_PORTSPEED_2GBIT},
+       {0x2000, FC_PORTSPEED_4GBIT},
+       {0x1000, FC_PORTSPEED_10GBIT},
+       {0x0800, FC_PORTSPEED_8GBIT},
+};
+
+/* speed_data is the bitmap that we want to check */
+static uint32_t fc_parse_gpsc_rsp(uint16_t speed_data)
+{
+       uint32_t ret = 0;
+       int i = 0;
+
+       for(i = 0; i < GSPC_VAL_SIZE; i++) {
+       if (speed_data & gpsc_val[i].gpsc_bit)
+               ret |= gpsc_val[i].fc_speed_bit;
+       }
+
+       return ret;
+}
+
+static int fc_parse_gpt_id(uint8_t port_type)
+{
+       int ret = FC_PORTTYPE_UNKNOWN;
+
+       switch (port_type) {
+       case FC_NS_N_PORT:
+       case FC_NS_NX_PORT:
+               ret = FC_PORTTYPE_NPORT;
+               break;
+       case FC_NS_NL_PORT:
+               ret = FC_PORTTYPE_NLPORT;
+               break;
+       case FC_NS_FNL_PORT:
+       case FC_NS_F_PORT:
+       case FC_NS_FL_PORT:
+       case FC_NS_E_PORT:
+       case FC_NS_B_PORT:
+               ret = FC_PORTTYPE_OTHER;
+               break;
+       case FC_NS_UNID_PORT:
+       default:
+               ret = FC_PORTTYPE_UNKNOWN;
+               break;
+       }
+
+       return ret;
+}
+
+static int fc_bsg_ct_ns_cmd(struct fc_rport *rport, uint16_t cmd)
+{
+       struct fc_ct_req *ct_req;
+       void *ct_resp;
+       uint64_t ret = -EIO;
+       int resp_size = 0;
+
+       if (rport->port_state != FC_PORTSTATE_ONLINE)
+               return ret;
+
+       ct_req = kzalloc(sizeof(struct fc_ct_req), GFP_KERNEL);
+       if (!ct_req) {
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       switch (cmd) {
+       case(FC_NS_GFPN_ID):
+               resp_size = sizeof(struct fc_ct_hdr) +
+                   sizeof(struct fc_ns_gid_pn);
+               break;
+       case(FC_NS_GFT_ID):
+               resp_size = sizeof(struct fc_ct_hdr) +
+                   sizeof(struct fc_ns_gft_id);
+               break;
+       case (FS_NS_GPT_ID):
+               resp_size = sizeof(struct fc_ct_hdr) +
+                   sizeof(struct fc_ns_pt_obj);
+               break;
+       case (FC_NS_GSPN_ID):
+               resp_size = sizeof(struct fc_ct_hdr) +
+                   sizeof(struct fc_ns_gspn_id);
+               break;
+       default:
+               ret = -EINVAL;
+               goto ct_req_out;
+       }
+
+       ct_resp = kzalloc(resp_size, GFP_KERNEL);
+       if (!ct_resp) {
+               ret = -ENOMEM;
+               goto ct_req_out;
+       }
+
+       fc_bsg_ct_assign_fid(ct_req, rport);
+       ret = fc_bsg_ct_cmd_execute(rport, FC_FST_DIR, cmd, ct_req, ct_resp,
+        resp_size);
+
+       if (ret >= 0 && fc_bsg_ct_check_rsp(ct_resp)) {
+               struct fc_ns_gid_pn *pn;
+               struct fc_ns_gft_id *fc4_types;
+               struct fc_ns_pt_obj *pt;
+               struct fc_ns_gspn_id *sn;
+
+               switch (cmd) {
+               case (FC_NS_GFPN_ID):
+                       pn = ct_resp + sizeof(struct fc_ct_hdr);
+                       rport->fabric_name = ntohll(pn->fn_wwpn);
+                       break;
+               case (FC_NS_GFT_ID):
+                       fc4_types = ct_resp + sizeof(struct fc_ct_hdr);
+                       memcpy(rport->supported_fc4s, fc4_types->fr_fc4_types,
+                           sizeof(struct fc_ns_gft_id));
+                       memcpy(rport->active_fc4s, fc4_types->fr_fc4_types,
+                           sizeof(struct fc_ns_gft_id));
+                       break;
+               case (FS_NS_GPT_ID):
+                       pt = ct_resp + sizeof(struct fc_ct_hdr);
+                       rport->port_type = fc_parse_gpt_id(pt->pt_type);
+                       break;
+               case (FC_NS_GSPN_ID):
+                       sn = ct_resp + sizeof(struct fc_ct_hdr);
+                       strncpy(rport->symbolic_name, sn->fr_sym_name,
+                           sn->fr_len);
+                       break;
+               }
+       }
+
+       kfree(ct_resp);
+ct_req_out:
+       kfree(ct_req);
+out:
+       return ret;
+}
+
+static int fc_bsg_ct_ms_cmd(struct fc_rport *rport, uint16_t cmd)
+{
+       struct fc_ct_req *ct_req;
+       void *ct_resp;
+       uint64_t ret = -EIO;
+       int resp_size = 0;
+
+       if (rport->port_state != FC_PORTSTATE_ONLINE)
+               return ret;
+
+       ct_req = kzalloc(sizeof(struct fc_ct_req), GFP_KERNEL);
+       if (!ct_req) {
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       switch (cmd) {
+       case(0x127): /* GPSC */
+               if (rport->fabric_name > 0)
+                       ct_req->payload.pn.fn_wwpn = htonll(rport->fabric_name);
+               else {
+                       ret = -EIO;
+                       goto ct_req_out;
+               }
+
+               resp_size = sizeof(struct fc_ct_hdr) +
+                   sizeof(struct fc_ms_gpsc);
+               break;
+       default:
+               ret = -EINVAL;
+               goto ct_req_out;
+       }
+
+       ct_resp = kzalloc(resp_size, GFP_KERNEL);
+       if (!ct_resp) {
+               ret = -ENOMEM;
+               goto ct_req_out;
+       }
+       ret = fc_bsg_ct_cmd_execute(rport, FC_FST_MGMT, cmd, ct_req, ct_resp,
+        resp_size);
+
+       if (ret >= 0 && fc_bsg_ct_check_rsp(ct_resp)) {
+               struct fc_ms_gpsc *gpsc;
+
+               switch (cmd) {
+               case (0x127): /* GPSC */
+                       gpsc = ct_resp + sizeof(struct fc_ct_hdr);
+                       rport->speed =
+                           fc_parse_gpsc_rsp(
+                               cpu_to_be16(gpsc->operating_speed));
+                       rport->supported_speeds =
+                           fc_parse_gpsc_rsp(
+                               cpu_to_be16(gpsc->port_speed_cap));
+                       break;
+               }
+       }
+
+       kfree(ct_resp);
+ct_req_out:
+       kfree(ct_req);
+out:
+       return ret;
+}

  /* Original Author:  Martin Hicks */
  MODULE_AUTHOR("James Smart");
diff --git a/include/scsi/fc/fc_ns.h b/include/scsi/fc/fc_ns.h
index f7751d5..30c7b72 100644
--- a/include/scsi/fc/fc_ns.h
+++ b/include/scsi/fc/fc_ns.h
@@ -41,7 +41,10 @@ enum fc_ns_req {
        FC_NS_GI_A =    0x0101,         /* get identifiers - scope */
        FC_NS_GPN_ID =  0x0112,         /* get port name by ID */
        FC_NS_GNN_ID =  0x0113,         /* get node name by ID */
+       FC_NS_GFT_ID =  0x0117,         /* get fc-4 types by ID */
        FC_NS_GSPN_ID = 0x0118,         /* get symbolic port name */
+       FS_NS_GPT_ID =  0x011a,         /* get port type by ID */
+       FC_NS_GFPN_ID = 0x011c,         /* get fabric port name */
        FC_NS_GID_PN =  0x0121,         /* get ID for port name */
        FC_NS_GID_NN =  0x0131,         /* get IDs for node name */
        FC_NS_GID_FT =  0x0171,         /* get IDs by FC4 type */
@@ -205,4 +208,27 @@ struct fc_ns_rff_id {
        __u8            fr_type;        /* FC-4 type */
  } __attribute__((__packed__));

+/*
+ * GFT_ID response
+ */
+struct fc_ns_gft_id {
+       __u8            fr_fc4_types[32];
+};
+
+/*
+ * GSPN_ID response
+ */
+struct fc_ns_gspn_id {
+       __u8            fr_len;
+       char            fr_sym_name[255];
+};
+
+/*
+ * GPSC response - get port speed capabilities
+ */
+struct fc_ms_gpsc {
+       __be16          port_speed_cap;
+       __be16          operating_speed;
+};
+
  #endif /* _FC_NS_H_ */
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index be418d8..ab23a35 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -43,6 +43,7 @@ struct fc_ct_req {
                struct fc_ns_fid fid;
                struct fc_ns_rsnn snn;
                struct fc_ns_rspn spn;
+               struct fc_ns_gid_pn pn;
        } payload;
  };

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 2a65167..6438a87 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -320,10 +320,23 @@ struct device_attribute dev_attr_rport_##_name =  \
   * managed by the transport w/o driver interaction.
   */

+/* Size arguments used for rport and host attributes */
+#define FC_FC4_LIST_SIZE               32
+#define FC_SYMBOLIC_NAME_SIZE          256
+#define FC_VERSION_STRING_SIZE         64
+#define FC_SERIAL_NUMBER_SIZE          80
+
  struct fc_rport {     /* aka fc_starget_attrs */
        /* Fixed Attributes */
        u32 maxframe_size;
        u32 supported_classes;
+       u8  supported_fc4s[FC_FC4_LIST_SIZE];
+       u32 supported_speeds;
+       enum fc_port_type port_type;
+       u32 speed;
+       u8  active_fc4s[FC_FC4_LIST_SIZE];
+       char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+       u64 fabric_name;

        /* Dynamic Attributes */
        u32 dev_loss_tmo;       /* Remote Port loss timeout in seconds. */
@@ -470,11 +483,6 @@ enum fc_host_event_code  {
   * managed by the transport w/o driver interaction.
   */

-#define FC_FC4_LIST_SIZE               32
-#define FC_SYMBOLIC_NAME_SIZE          256
-#define FC_VERSION_STRING_SIZE         64
-#define FC_SERIAL_NUMBER_SIZE          80
-
  struct fc_host_attrs {
        /* Fixed Attributes */
        u64 node_name;
@@ -680,6 +688,15 @@ struct fc_function_template {
        /* remote port fixed attributes */
        unsigned long   show_rport_maxframe_size:1;
        unsigned long   show_rport_supported_classes:1;
+
+       /* Extended rport attributes which are not shown be default */
+       unsigned long   show_rport_supported_fc4s:1;
+       unsigned long   show_rport_supported_speeds:1;
+       unsigned long   show_rport_port_type:1;
+       unsigned long   show_rport_speed:1;
+       unsigned long   show_rport_active_fc4s:1;
+       unsigned long   show_rport_symbolic_name:1;
+       unsigned long   show_rport_fabric_name:1;
        unsigned long   show_rport_dev_loss_tmo:1;

        /*
--
1.7.0.31.g1df487


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

