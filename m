From: Christoph Hellwig <hch@infradead.org>
Subject: Re: suspicious code in hosts.c
Date: Fri, 29 Nov 2002 15:56:12 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021129155611.A26444@infradead.org>
References: <20021129154455Z267086-22911+3959@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021129154455Z267086-22911+3959@vger.kernel.org>; from lwseaman@excite.com on Fri, Nov 29, 2002 at 10:44:55AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Lyle Seaman <lwseaman@excite.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 29, 2002 at 10:44:55AM -0500, Lyle Seaman wrote:
> scsi_tp_for_each_host drops the scsi_host_list_lock, does some work,
> then picks up the lock and continues traversing the list.  It naively
> uses list_for_each_safe, but that is only safe for non-preemptive,
> non-yielding, single-processor applications.  Is there some other lock
> that prevents the scsi_host_list from being altered behind my back
> while I'm in scsi_tp_for_each_host ?  I don't see it.  It sure looks
> like it could race with scsi_unregister, for instance.
> 
> Also, scsi_register_host runs without locking the list?
> 
> And scsi_unregister_host uses the BKL but not the scsi_host_list_lock?
> 
> I don't know enough about the scsi subsystem to be certain that these are
> wrong, or that I know how to fix them, but they seem awfully
> suspicious and are at best confusing.   What am I missing?

You're not missing anything, locking in the scsi midlayer is totally
busted.  We're now in a state where the scsi midlayer is in a shape
that we can start to properly lock it down and that will happen very soon.
