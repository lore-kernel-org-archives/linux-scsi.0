From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator
	for Linux
Date: Sat, 05 Mar 2005 17:02:15 -0800
Message-ID: <422A5697.2000905@cs.wisc.edu>
References: <4229e34e.7e535078.5bc3.0b5eSMTPIN_ADDED@mx.googlegroups.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4229e34e.7e535078.5bc3.0b5eSMTPIN_ADDED@mx.googlegroups.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alex Aizman wrote:
> This is to announce Open-iSCSI project: High-Performance iSCSI Initiator for
> Linux.
> 
> MOTIVATION
> ==========
> 
> Our initial motivations for the project were: (1) implement the right
> user/kernel split, and (2) design iSCSI data path for performance. Recently
> we added (3): get accepted into the mainline kernel.
>  
> As far as user/kernel, the existing iSCSI initiators bloat the kernel with
> ever-growing control plane code, including but not limited to: iSCSI
> discovery, Login (Authentication and Operational), session and connection
> management,

For iscsi-sfnet, I know it does login and auth and session and connection
management/recovery in kernel becuase nobody has been able to write a usersapce
daemon that can survive memory allocation failures and being paged out - are
there other problems when dealing with usersapce like this. Open-iscsi seems
to suffer from those problems too, but they seem like they can be fixed relatively
quickly. Do you know how long it will take? Is it still two months with some of
the items I descibed on the open-iscsi list in mind and after looking at what dm
multipath has had to do to perform failback and path checking?

As you know I agree it should be done in usersapce so please spare me the usual
advertisements and magic I normally get ;) I do not need to be sold on the
concept. I am just trying to get a better picture of if people will merge the
kernel part with a unreliable userspace component. If so then many sourceforge
devs can help test as there is no point in target vendors on that list
fixing the same bugs on multiple stacks like I have been doing (almost had
Pyx fixed with IBM DS300 too).

If the problems of doing recovery/login/auth in usersapce are solved and
well known should dm multipath move its failover to usersapce too? Doing
explicit failover is essentialy the same problem and there is no point in
sticking in a kernel interface for dm hw handlers when it can be done in
usersapce. I mention this becuase of the MCS embargo, and the fact the
I cannot imagine many storage admins running iSCSI without some sort
of multipath or failover so I would like to get that ironed out too.
