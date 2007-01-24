From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 24 Jan 2007 01:09:13 +0100
Message-ID: <45B6A3A9.1010603@s5r6.in-berlin.de>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org> <45B64308.1060703@s5r6.in-berlin.de> <45B6884E.9040700@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41380 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbXAXAJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 19:09:26 -0500
In-Reply-To: <45B6884E.9040700@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> Stefan Richter wrote:
...
>>   - vscsihba enters scsi_remove_host() or scsi_remove_device(),
>>   - SCSI core and upper layers do whatever it takes to withdraw from
>>     the respective I-T(-L) nexus gracefully (e.g. synchronize cache,
>>     unlock drive door...),
>>   
> Does this happen automatically when the scsi_remove_host() is called,

Yes. The SCSI core passes the remove/shutdown request up to the higher
layers like sd_mod for orderly shutdown. There is no distinction between
regular shutdown and hot-unplug in SCSI core or above; these layers
treat everything as regular shutdown. Only the LLD can (and has to) make
this distinction.
-- 
Stefan Richter
-=====-=-=== ---= ==---
http://arcgraph.de/sr/
