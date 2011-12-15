From: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Thu, 15 Dec 2011 12:18:47 -0500
Message-ID: <4EEA2BF7.5030107@gmail.com>
References: <4EE8F75F.6070800@gmail.com>  <20111214192739.GN2203@ZenIV.linux.org.uk> <4EE8FC2E.3010207@gmail.com>  <20111214222723.GD7623@fieldses.org>  <1323961140.14317.2.camel@lade.trondhjem.org>  <D3F292ADF945FB49B35E96C94C2061B91516E391@nsmail.netscout.com>  <1323965498.14317.13.camel@lade.trondhjem.org>  <D3F292ADF945FB49B35E96C94C2061B91516E3FC@nsmail.netscout.com> <1323968015.14317.28.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323968015.14317.28.camel-SyLVLa/KEI9HwK5hSS5vWB2eb7JE58TQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: "Loke, Chetan" <Chetan.Loke-Wi0MfyythtRWk0Htik3J/w@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/15/2011 11:53 AM, Trond Myklebust wrote:
> On Thu, 2011-12-15 at 11:40 -0500, Loke, Chetan wrote:
>>>> Why not support something like the async-iocb?
>>> You could, but that would tie copyfile() to the aio interface which was
>>> one of the things that I believe Al was opposed to when we discussed
>>> this at LSF/MM-2010.
>>>
>> virtualization vendors who support this offload do it at a layer above the guest-OS(Intra-LUN(tm) locking or whatever fancy locking). So I think 'copyfile' is going to be appealing to application-developers more than the hypervisor-vendors.
> The application is thin provisioning, not the 'cp' command. When
> virtualisation vendors do support this, it will mainly be as part of
> their image management toolkits, not the hypervisor.

I think that hypervisor vendors will be very interested in this feature which 
would explain why vmware was active in drafting both the NFS and T10 specs. Not 
to mention those of us who use KVM or XEN :)

As Trond mentions, we might have this in the management tool chain or other 
places in the stack.

>
>> So let's think about it from end-users perspective:
>> Won't everyone replicate code to check - 'Am I done'? It will just make application folks write more (ugly)code. Because you would then have to maintain another queue/etc to check for this operation.
> 'Am I done' is easy: copyfile() returns with the number of bytes that
> have been copied.
>
> 'Is my copyfile() syscall making progress' is the question that needs
> answering.
>
>> We can just support full-copy. Partial copies can be returned as failure.
> Then you have to check the entire range on error instead of just
> resuming the copy from where it stopped.
>

I also like simple first. I am not too certain about the need for polling 
(especially given how little we have done historically to take advantage of the 
notifications, water marks, etc in things like thin provisioning :)).

On the other hand, I also don't object to having the ability to poll (through 
the ioctl or whatever) if others find that useful.

What I would like to see is a way to make sure that we can interrupt any long 
running command & also make sure that our timeouts (for SCSI specifically) are 
not too aggressive.

Ric


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
