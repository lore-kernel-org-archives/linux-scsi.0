From: Hannes Reinecke <hare@suse.de>
Subject: ibmvfc oddities
Date: Thu, 21 Sep 2017 12:02:34 +0200
Message-ID: <a0969601-e06a-7b90-36f0-357c54bfbfe7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751675AbdIUKCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 06:02:36 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian king <brking@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Brian,

I was looking at the ibmvfc code (trying to hook up libfc), and have
found this definition:

struct ibmvfc_fcp_rsp_info {
	__be16 reserved;
	u8 rsp_code;
	u8 reserved2[4];
}__attribute__((packed, aligned (2)));

in comparison, libfc has this:

struct fcp_resp_rsp_info {
    __u8      _fr_resvd[3];       /* reserved */
    __u8      rsp_code;           /* Response Info Code */
    __u8      _fr_resvd2[4];      /* reserved */
};

So both look _nearly_ identical, except the missing byte at the start.
It might be inserted due to some compile alignment magic, but I'd rather
not rely on this.
Could you clarify if the two structures really are different, or if this
is a simple oversight?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
