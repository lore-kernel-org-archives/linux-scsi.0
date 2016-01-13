From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
	ACK_KREF
Date: Wed, 13 Jan 2016 09:34:46 +0100
Message-ID: <20160113083446.GA13330@lst.de>
References: <1452594245-921-1-git-send-email-nab@daterainc.com> <1452594245-921-2-git-send-email-nab@daterainc.com> <20160112152059.GB2294@lst.de> <56952AB0.1070806@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56952AB0.1070806@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2016 at 08:32:48AM -0800, Bart Van Assche wrote:
> Hello Christoph,
>
> How about eliminating the TARGET_SCF_ACK_KREF flag ? If a command would 
> only be freed upon the last target_put_sess_cmd() call then I think that 
> the check_stop_free() callback wouldn't have to call target_put_sess_cmd() 
> and hence that the TARGET_SCF_ACK_KREF flag could be removed.

Yes, that's what I meant.  I think it shoul be generally feasibly, but
would require a careful audit of the !TARGET_SCF_ACK_KREF code path
first.
