From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Wed, 13 Jan 2016 01:14:37 -0800
Message-ID: <1452676477.27508.56.camel@haakon3.risingtidesystems.com>
References: <1452594245-921-1-git-send-email-nab@daterainc.com>
	 <1452594245-921-2-git-send-email-nab@daterainc.com>
	 <20160112152059.GB2294@lst.de> <56952AB0.1070806@sandisk.com>
	 <20160113083446.GA13330@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160113083446.GA13330@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 09:34 +0100, Christoph Hellwig wrote:
> On Tue, Jan 12, 2016 at 08:32:48AM -0800, Bart Van Assche wrote:
> > Hello Christoph,
> >
> > How about eliminating the TARGET_SCF_ACK_KREF flag ? If a command would 
> > only be freed upon the last target_put_sess_cmd() call then I think that 
> > the check_stop_free() callback wouldn't have to call target_put_sess_cmd() 
> > and hence that the TARGET_SCF_ACK_KREF flag could be removed.
> 
> Yes, that's what I meant.  I think it shoul be generally feasibly, but
> would require a careful audit of the !TARGET_SCF_ACK_KREF code path
> first.

No, no, no.

The whole point of TARGET_SCF_ACK_KREF was so the backend driver
completion path calling check_stop_free() for one ->cmd_kref, and the
fabric driver patch calling target_put_sess_cmd() for the second
->cmd_kref both complete before attempting to free se_cmd memory.

The hw fabric drivers that have a hard requirement for
TARGET_SCF_ACK_KREF already use it, but it wouldn't hurt to convert the
remaining ones to use it.
