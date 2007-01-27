From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] qla4xxx: bug fixes
Date: Sat, 27 Jan 2007 10:08:22 -0600
Message-ID: <1169914102.4392.5.camel@mulgrave.il.steeleye.com>
References: <1169497571.12416.2.camel@linux-58to>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46062 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbXA0QIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2007 11:08:32 -0500
In-Reply-To: <1169497571.12416.2.camel@linux-58to>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>

On Mon, 2007-01-22 at 12:26 -0800, David C Somayajulu wrote:
> The included patch fixes the following issues:
> 1. qla3xxx/qla4xxx co-existence issue which can result in a lockup when qla3xxx driver is unloaded, or when ifdown; ifup is performed on one of the interfaces correponding to qla3xxx. This is because qla4xxx HBA supports one ethernet and iscsi interfaces per port. Both iscsi and ethernet interfaces share the same state machine. The problem has to do with synchronizing access to the state machine in the event of a reset
> 2. mutex_lock() is sometimes not followed by mutex_unlock() prior to invoking a msleep() in qla4xxx_mailbox_command()

Git applymbox picked up this nasty (which I've corrected):

Applying 'qla4xxx: bug fixes'

Space in indent is followed by a tab.
.dotest/patch:122:                      set_bit(AF_MBOX_COMMAND,
&ha->flags);
Space in indent is followed by a tab.
.dotest/patch:123:                      mutex_unlock(&ha->mbox_sem);
Space in indent is followed by a tab.
.dotest/patch:124:                      break;
Space in indent is followed by a tab.
.dotest/patch:125:              }
Space in indent is followed by a tab.
.dotest/patch:126:              mutex_unlock(&ha->mbox_sem);
warning: squelched 7 whitespace errors
warning: 12 lines add trailing whitespaces.

James


