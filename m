From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: qla2xxx behavior with changing volumes
Date: Fri, 21 Sep 2007 20:12:01 +0400
Message-ID: <46F3ED51.5030703@vlnb.net>
References: <1190175126.4408.5.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:55221 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbXIUQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2007 12:42:07 -0400
In-Reply-To: <1190175126.4408.5.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

Sean Bruno wrote:
> What is the expected behavior when volumes on a SAN change size and LUN
> ID order?
> 
> I've noticed that if a volume changes size, leaves the SAN or changes
> target ID it isn't auto-magically picked up by a 2.6.18 based
> system(running CentOS 5).
> 
> If a new target appears on the SAN however, it is noticed and assigned a
> new drive letter.

For changes in the volume size the target (SAN) should generate 
"CAPACITY DATA HAS CHANGED" Unit Attention.

For changes in the LUN ID order the target should generate "REPORTED 
LUNS DATA HAS CHANGED" Unit Attention.

On these notifications initiator is supposed to make the appropriate 
actions, like rescan the SAN in case of "REPORTED LUNS DATA HAS 
CHANGED". Unfortunately, Linux just ignores them as well as the majority 
of other Unit Attentions, hence you have to restart the system or, at 
least, the corresponding driver to see the changes.

Vlad
