From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 18:54:16 +0200
Message-ID: <4FD77438.6090202@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com> <4FD76D57.5020709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FD76D57.5020709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 12/06/2012 18:24, Paolo Bonzini ha scritto:
> Il 12/06/2012 18:21, James Bottomley ha scritto:
>>>> Persistent reservations commands cannot be issued right now without
>>>> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
>>>> is a bit heavy-handed, allow these two commands.
>>
>> Why is this heavy handed?  If you remove CAP_SYS_RAWIO, any userspace
>> process can send these, which would allow any user to completely disrupt
>> a SAN by injecting spurious reservations ... that doesn't look to be
>> terribly safe for an operating system running in a data centre.
> 
> It is heavy-handed because:
> 
> 1) there are still other protections such as DAC (both Unix permissions
> and ACLs) and SELinux; CAP_SYS_RAWIO is effectively the same as root.
> 
> 2) if any user could disrupt the SAN by injecting spurious reservations
> just by having his laptop's root password, that data centre wouldn't be
> terribly safe to begin with.

3) assume that with this patch user X could disrupt the SAN by injecting
spurious reservations, e.g. forbidding another user from writing some
data.  Then they could also destroy those same data even without this
patch, which is just as disrupting.

This is because you still need write permission to the device to issue
reservations.  Read permission will only let you use PERSISTENT RESREVE IN.

Paolo
