From: Douglas Gilbert <dougg@torque.net>
Subject: scsi_add_host() context
Date: Mon, 18 Nov 2002 12:26:38 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD841CE.3010309@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org

While examining the various calls in the mid level that
can be called from a LLD, most are designed to
be called from an interrupt or related context
(e.g. scsi_adjust_queue_depth() ).

However, the detection of a new host requires a LLD to call 
scsi_register() and scsi_add_host(). The latter call does
a SCSI bus scan which takes time and sends commands like
INQUIRY and REPORT_LUNS back through the LLD. So scsi_add_host()
should not be called from an interrupt context. Can this be
guaranteed in a hotplug environment? Is a worker thread
required?

Doug Gilbert

