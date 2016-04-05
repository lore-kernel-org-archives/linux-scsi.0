From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 0/2] target: make location of /var/target configurable
Date: Mon, 4 Apr 2016 18:15:27 -0700
Message-ID: <570311AF.4070709@suse.com>
References: <cover.1459278305.git.lduncan@suse.com>
 <1459654584.13184.39.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1459654584.13184.39.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, Andy Grover <agrover@redhat.com>, Jerome Martin <jxm@netiant.com>
List-Id: linux-scsi@vger.kernel.org

On 04/02/2016 08:36 PM, Nicholas A. Bellinger wrote:
> On Thu, 2016-03-31 at 11:05 -0700, Lee Duncan wrote:
>> These patches make the location of "/var/target" configurable,
>> though it still defauls to "/var/target".
>>
>> This configuration is accomplished via the configfs
>> top-level target attribute "dbroot", i.e. dumping
>> out "/sys/kernel/config/target/dbroot" will normally
>> return "/var/target". Writing to this attribute
>> changes the loation where the kernel looks for the
>> target database.
>>
>> ** NOTE/QUESTION: no sanity checks are done on the path passed in,
>>    but it seems like *some* should be done. At least checking that
>>    it's an abosolute path (i.e. starts with '/')? Opinions?
>>
> 
> Wrt to sanity checking db_root at configfs attribute store time, how
> about doing a filp_open() + S_DIR(f_inode->imode) + filp_close() of the
> requested path to verify it's really a directory..?

That seems reasonable. I will try that out and add it assuming it works. :)

> 
> Also, it would probably be a good idea to limit when db_root can be
> changed.  Eg, only allow db_root to be changed when no active target
> fabric drivers have been registered (list_empty(g_tf_list)), and require
> userspace to set a different db_root after modprobe target_core_mod
> completes, but before any fabric drivers are loaded.
> 

I will also try that.

Would it be worthwhile to have a module parameter for target_core_mod to
set the root, so it could be accomplished at the right time? (As much as
I like playing with configfs.)

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Lee Duncan
SUSE Labs
