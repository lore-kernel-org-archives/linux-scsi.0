From: Parav Pandit <paravpandit@yahoo.com>
Subject: returning scsi I/O to OS from interrupt handler
Date: Sun, 26 Aug 2007 09:11:38 -0700 (PDT)
Message-ID: <474470.84138.qm@web30115.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30115.mail.mud.yahoo.com ([209.191.69.47]:46477 "HELO
	web30115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752835AbXHZQLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Aug 2007 12:11:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

A low level SCSI HBA driver can return the I/O back to
the OS from various paths.

Some of the common possible paths
1, enqueue_command itself
2. Timer handler (at the time of command timeout)
3. Interrupt handler (when a response is received from
the storage)
4. DPC handler thread.

Whenever an I/O is returned from the interrupt handler
by invoking scsi_done callback function, it will
invoke the SCSI mid layer.

1. Is it good practice to return call scsi_done
callback function from Interrupt handler? 
If no, may I know the implications of doing that?
(other then blocking the interrupt context for a
longer time)

2. if multiple I/Os are returned in a single
interrupt, how many  commands should be returned by
calling scsi_done before shifting to dpc thread?

Regards,
Parav Pandit



       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
