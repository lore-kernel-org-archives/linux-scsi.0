From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 3 Aug 2016 22:01:45 +0300
Message-ID: <20160803190145.GD775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33643 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbcHCTDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 15:03:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bryantly@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Hello Bryant G. Ly,

The patch 88a678bbc34c: "ibmvscsis: Initial commit of IBM VSCSI Tgt
Driver" from Jun 28, 2016, leads to the following static checker
warning:

	drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1981 ibmvscsis_srp_login()
	warn: suspicious bitop condition

drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
  1967          iport = (struct port_id *)req->initiator_port_id;
  1968          tport = (struct port_id *)req->target_port_id;
  1969          fmt = (struct format_code *)&req->req_buf_fmt;
  1970          if (be32_to_cpu(req->req_it_iu_len) > SRP_MAX_IU_LEN)
  1971                  reason = SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE;
  1972          else if (be32_to_cpu(req->req_it_iu_len) < 64)
  1973                  reason = SRP_LOGIN_REJ_UNABLE_ESTABLISH_CHANNEL;
  1974          else if ((be64_to_cpu(iport->id_extension) > (MAX_NUM_PORTS - 1)) ||
  1975                   (be64_to_cpu(tport->id_extension) > (MAX_NUM_PORTS - 1)))
  1976                  reason = SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL;
  1977          else if (req->req_flags & SRP_MULTICHAN_MULTI)
  1978                  reason = SRP_LOGIN_REJ_MULTI_CHANNEL_UNSUPPORTED;
  1979          else if (fmt->buffers & (~SUPPORTED_FORMATS))
  1980                  reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
  1981          else if ((fmt->buffers | SUPPORTED_FORMATS) == 0)
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SUPPORTED_FORMATS is 1 << 1 so it's never zero.

  1982                  reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
  1983  
  1984          if (vscsi->state == SRP_PROCESSING)
  1985                  reason = SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED;
  1986  


regards,
dan carpenter
