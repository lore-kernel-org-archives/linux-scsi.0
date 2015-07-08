From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 04:44:24 -0700
Message-ID: <20150708114424.GA13943@infradead.org>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org>
 <559CFD14.9090803@dev.mellanox.co.il>
 <20150708104955.GA20842@infradead.org>
 <559D0286.4070202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559D0286.4070202@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 08, 2015 at 12:59:18PM +0200, Hannes Reinecke wrote:
> Actually it's controlled by the D_SENSE bit in the Control mode page
> (that's bit[2] of byte 2 in the control mode page).
> Which is currently set to '0', ie we will be returning fixed sense
> information.
> _If_ we were to report descriptor sense we will need to change that,
> too.

Just looked over SPC, and indeed D_SENSE is a strict either fixed
or descriptor, not a may return descriptor data.

So this patch actually is wrong as we never must return different sense
data types based on the sense code.
