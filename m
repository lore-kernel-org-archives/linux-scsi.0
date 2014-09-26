From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: Add FDMI-2 functionality.
Date: Fri, 26 Sep 2014 18:08:19 +0300
Message-ID: <20140926150819.GB11817@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbaIZPJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 11:09:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello Himanshu Madhani,

The patch df57cabac41f: "qla2xxx: Add FDMI-2 functionality." from Sep
25, 2014, leads to the following static checker warnings:

drivers/scsi/qla2xxx/qla_gs.c:1339 qla2x00_fdmi_rhba() error: snprintf() chops off the last chars of 'ha->model_number': 17 vs 16
drivers/scsi/qla2xxx/qla_gs.c:1628 qla2x00_fdmi_rpa() error: snprintf() chops off the last chars of 'p_sysid->nodename': 65 vs 32
drivers/scsi/qla2xxx/qla_gs.c:1631 qla2x00_fdmi_rpa() error: snprintf() chops off the last chars of '(((vha->host)->shost_data)->system_hostname)': 256 vs 32
drivers/scsi/qla2xxx/qla_gs.c:1763 qla2x00_fdmiv2_rhba() error: snprintf() chops off the last chars of 'ha->model_number': 17 vs 16
drivers/scsi/qla2xxx/qla_gs.c:2195 qla2x00_fdmiv2_rpa() error: snprintf() chops off the last chars of 'p_sysid->nodename': 65 vs 32
drivers/scsi/qla2xxx/qla_gs.c:2198 qla2x00_fdmiv2_rpa() error: snprintf() chops off the last chars of '(((vha->host)->shost_data)->system_hostname)': 256 vs 32

drivers/scsi/qla2xxx/qla_gs.c
  2194          if (p_sysid) {
  2195                  snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
  2196                      "%s", p_sysid->nodename);

We're chopping most of the hostname off.  That seems bad.

  2197          } else {
  2198                  snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
  2199                      "%s", fc_host_system_hostname(vha->host));
  2200          }

regards,
dan carpenter
