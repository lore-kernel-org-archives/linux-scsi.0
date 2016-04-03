From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: make location of /var/target configurable
Date: Sat, 02 Apr 2016 20:36:24 -0700
Message-ID: <1459654584.13184.39.camel@haakon3.risingtidesystems.com>
References: <cover.1459278305.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1459278305.git.lduncan@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, Andy Grover <agrover@redhat.com>, Jerome Martin <jxm@netiant.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-03-31 at 11:05 -0700, Lee Duncan wrote:
> These patches make the location of "/var/target" configurable,
> though it still defauls to "/var/target".
> 
> This configuration is accomplished via the configfs
> top-level target attribute "dbroot", i.e. dumping
> out "/sys/kernel/config/target/dbroot" will normally
> return "/var/target". Writing to this attribute
> changes the loation where the kernel looks for the
> target database.
> 
> ** NOTE/QUESTION: no sanity checks are done on the path passed in,
>    but it seems like *some* should be done. At least checking that
>    it's an abosolute path (i.e. starts with '/')? Opinions?
> 

Wrt to sanity checking db_root at configfs attribute store time, how
about doing a filp_open() + S_DIR(f_inode->imode) + filp_close() of the
requested path to verify it's really a directory..?

Also, it would probably be a good idea to limit when db_root can be
changed.  Eg, only allow db_root to be changed when no active target
fabric drivers have been registered (list_empty(g_tf_list)), and require
userspace to set a different db_root after modprobe target_core_mod
completes, but before any fabric drivers are loaded.
