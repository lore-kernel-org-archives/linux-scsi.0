From: Sergey Kononenko <sergk@sergk.org.ua>
Subject: [PATCH 0/2] aic94xx: Supermicro motherboards support
Date: Sun, 15 Oct 2006 02:31:00 +0300
Message-ID: <20061015023100.390ee1b7@manowar.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.hqhost.net ([80.77.80.130]:22704 "EHLO mail2.hqhost.net")
	by vger.kernel.org with ESMTP id S1750892AbWJNXbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 19:31:04 -0400
Received: from manowar.localnet (ukrtel-nat.ua-online.net [213.179.225.5])
	(authenticated bits=0)
	by mail2.hqhost.net (8.13.8/8.13.8/Debian-2) with ESMTP id k9ENVHfP001011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2006 23:31:21 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

The aic94xx driver in current mainline kernel don't work with
controllers integrated in some of Supermicro motherboards (i have
tested only on X6DHR-3G2) due to two reasons:
- driver do not contain corresponding PCI id (9005:041F)
- driver can not find flash on controller.

Patches which i send now ordered to resolve this problems.

First one is a simple and just add pci id, but second one is a bit
controversial.

The following code from function asd_flash_getid (aic94xx_sds.c)

	reg = asd_read_reg_dword(asd_ha, EXSICNFGR);

        if (!(reg & FLASHEX)) {
                ASD_DPRINTK("flash doesn't exist\n");
                return -ENOENT;
        }

failed with error on controllers in supermicro motherboards.
Looks like flag FLASHEX did not set on such devices, however flash chip
present and without above if statement in code drivers works normally
on supermicro controllers.

As i found this code was commented out in original driver by Luben
Tuikov with following comment:

/*     Early (current?) SuperMicro mainboards, X6DHR-3G2 and X6DH3-G2
       have a bug whereby RS104 is missing (not installed) and RS103
       is installed, causing FLASHEX to be 0. */
/*     if (!(reg & FLASHEX)) { */
/*             ASD_DPRINTK("flash doesn't exist\n"); */
/*             return -ENOENT; */
/*     } */

May be it is possible to write separate code for checking
availability of flash chip especially for supermicro
motherboards, but i don't know hot it possible and don't know what is
RS104, RS103 and difference between it.

But more likely that check of FLASHEX can be removed safely from code
because below there is another more generic check for flash chip via
pci config probe.

This solution works perfect in my case, also it was in original code,
however i think this second patch would be tested on some other
varieties of aic94xx hardware.

--
Sergey Kononenko
