From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] qla4xxx: fix flash/ddb support
Date: Tue, 13 Nov 2012 16:01:21 +0300
Message-ID: <20121113130120.GA30734@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2KMNBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2012 08:01:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

Hello Mike Christie,

The patch 13483730a13b: "[SCSI] qla4xxx: fix flash/ddb support" from
Dec 1, 2011, leads to the following warning:
drivers/scsi/qla4xxx/ql4_os.c:714 qla4xxx_ep_connect()
	 error: memcpy() 'dst_addr' too small (16 vs 28)

I've sort of reported this bug before because it exhibits itself in more
than one way.

  4684  static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
  4685                                          struct dev_db_entry *fw_ddb_entry)
  4686  {
  4687          struct iscsi_endpoint *ep;
  4688          struct sockaddr_in *addr;
  4689          struct sockaddr_in6 *addr6;
  4690          struct sockaddr *dst_addr;

addr6 is 28 bytes.
dst_addr is 16 bytes.

  4691          char *ip;
  4692  
  4693          /* TODO: need to destroy on unload iscsi_endpoint*/
  4694          dst_addr = vmalloc(sizeof(*dst_addr));

We allocate 16 bytes.

  4695          if (!dst_addr)
  4696                  return NULL;
  4697  
  4698          if (fw_ddb_entry->options & DDB_OPT_IPV6_DEVICE) {
  4699                  dst_addr->sa_family = AF_INET6;
  4700                  addr6 = (struct sockaddr_in6 *)dst_addr;
  4701                  ip = (char *)&addr6->sin6_addr;
  4702                  memcpy(ip, fw_ddb_entry->ip_addr, IPv6_ADDR_LEN);

This memcpy() is copying 16 bytes into (u8 *)dst_addr + 8 so it's
corrupting 8 bytes of data past the end of the dst_addr struct.

  4703                  addr6->sin6_port = htons(le16_to_cpu(fw_ddb_entry->port));
  4704  
  4705          } else {
  4706                  dst_addr->sa_family = AF_INET;
  4707                  addr = (struct sockaddr_in *)dst_addr;
  4708                  ip = (char *)&addr->sin_addr;
  4709                  memcpy(ip, fw_ddb_entry->ip_addr, IP_ADDR_LEN);
  4710                  addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
  4711          }
  4712  
  4713          ep = qla4xxx_ep_connect(ha->host, dst_addr, 0);
                                                  ^^^^^^^^
There is another memcpy() inside the call to qla4xxx_ep_connect() which
reads beyond the end of the array.

regards,
dan carpenter

