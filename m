From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/4] target: Eliminate se_port +
 t10_alua_tg_pt_gp_member
Date: Tue, 26 May 2015 22:13:02 -0700
Message-ID: <1432703582.26863.33.camel@haakon3.risingtidesystems.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
	 <55646A9E.5050401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55646A9E.5050401@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-26 at 14:44 +0200, Bart Van Assche wrote:
> On 05/26/15 08:57, Nicholas A. Bellinger wrote:
> >    - Add various rcu_dereference and lockless_dereference RCU notation
> 
> Hello Nic,
> 
> Feedback from an RCU expert (which I'm not) would be appreciated here. 
> But my understanding is that lockless_dereference(p) should be used for 
> a pointer p that has *not* been annotated as an RCU pointer. I think in 
> the for-next branch of the target repository that this macro is used to 
> access RCU-annotated pointers. Is that why sparse complains about how 
> lockless_dereference() is used in the target tree ?
> 

Was curious about this myself..  Thanks for raising the question!

The intention of lockless_dereference() in both this and preceding
series is for __rcu protected pointers that are accessed outside of
rcu_read_lock() protection, and who's lifetime is controlled by a:

  - struct kref
  - struct percpu_ref
  - struct config_group symlink
  - RCU updater path with some manner of mutex or spinlock held

This is supposed to be following Paul's comment in rcupdate.h:

 * Similar to rcu_dereference(), but for situations where the pointed-to
 * object's lifetime is managed by something other than RCU.  That
 * "something other" might be reference counting or simple immortality.

Paul, would you be to kind to clarify the intention for us..?

Thank you,

--nab
