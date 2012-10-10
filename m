From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: [PATCH 3.6.0- 0/6] SCSI: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:18 +0100
Message-ID: <1349894058-8194-1-git-send-email-srinivas.kandagatla@st.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:45146 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2JJSgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 14:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: srinivas.kandagatla@st.com, fthain@telegraphics.com.au, JBottomley@Parallels.com, tsbogend@alpha.frankende, linux-scsi@vger.kernel.org, grant.likely@secretlab.ca, davem@davemloft.net

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Running below Coccinelle lookup pattern like below on the 
latest kernel showed about 52 hits. This patch series is a subset 
of those 52 patches, so that it will be easy for maintainers to review.
Hopefully these patches will get rid of some code duplication in kernel.


@  @
- initfunc(void)
- { return platform_driver_register(&dr); }

...

- module_init(initfunc);
...

- exitfunc(void)
- { platform_driver_unregister(&dr); }

...

- module_exit(exitfunc);
+ module_platform_driver(dr); 

Srinivas Kandagatla (6):
  scsi/jazz_esp: use module_platform_driver macro
  scsi/mac_esp: use module_platform_driver macro
  scsi/qlogicpti: use module_platform_driver macro
  scsi/sni_53c710: use module_platform_driver macro
  scsi/sun3x_esp: use module_platform_driver macro
  scsi/sun_esp: use module_platform_driver macro

 drivers/scsi/jazz_esp.c   |   14 +-------------
 drivers/scsi/mac_esp.c    |   14 +-------------
 drivers/scsi/qlogicpti.c  |   14 +-------------
 drivers/scsi/sni_53c710.c |   14 +-------------
 drivers/scsi/sun3x_esp.c  |   14 +-------------
 drivers/scsi/sun_esp.c    |   14 +-------------
 6 files changed, 6 insertions(+), 78 deletions(-)

