From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v4 30/32] cxlflash: Fix to avoid corrupting adapter fops
Date: Tue, 29 Sep 2015 10:54:15 +1000
Message-ID: <5609E137.6000301@au1.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223164-10077-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48974 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbbI2Ay4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 20:54:56 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 29 Sep 2015 10:54:53 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id D75EF2CE8052
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 10:54:49 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8T0sfi457212950
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 10:54:49 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8T0sG8H007891
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 10:54:17 +1000
In-Reply-To: <1443223164-10077-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 26/09/15 09:19, Matthew R. Ochs wrote:
> The fops owned by the adapter can be corrupted in certain scenarios,
> opening a window where certain fops are temporarily NULLed before being
> reset to their proper value. This can potentially lead software to make
> incorrect decisions, leaving the user with the inability to function as
> intended.
>
> An example of this behavior can be observed when there are a number of
> users with a high rate of turn around (attach to LUN, perform an I/O,
> detach from LUN, repeat). Every so often a user is given a valid
> context and adapter file descriptor, but the file associated with the
> descriptor lacks the correct read permission bit (FMODE_CAN_READ) and
> thus the read system call bails before calling the valid read fop.
>
> Background:
>
> The fops is stored in the adapter structure to provide the ability to
> lookup the adapter structure from within the fop handler. CXL services
> use the file's private_data and at present, the CXL context does not
> have a private section. In an effort to limit areas of the cxlflash
> driver with code specific the superpipe function, a design choice was
> made to keep the details of the fops situated away from the legacy
> portions of the driver. This drove the behavior that the adapter fops
> is set at the beginning of the disk attach ioctl handler when there
> are no users present.
>
> The corruption that this fix remedies is due to the fact that the fops
> is initially defaulted to values found within a static structure. When
> the fops is handed down to the CXL services later in the attach path,
> certain services are patched. The fops structure remains correct until
> the user count drops to 0 and the fops is reset, triggering the process
> to repeat again. The user counts are tightly coupled with the creation
> and deletion of the user context. If multiple users perform a disk
> attach at the same time, when the user count is currently 0, some users
> can be in the middle of obtaining a file descriptor and have not yet
> reached the context creation code that [in addition to creating the
> context] increments the user count. Subsequent users coming in to
> perform the attach see that the user count is still 0, and reinitialize
> the fops, temporarily removing the patched fops. The users that are in
> the middle obtaining their file descriptor may then receive an invalid
> descriptor.
>
> The fix simply removes the user count altogether and moves the fops
> initialization to probe time such that it is only performed one time
> for the life of the adapter. In the future, if the CXL services adopt
> a private member for their context, that could be used to store the
> adapter structure reference and cxlflash could revert to a model that
> does not require an embedded fops.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

