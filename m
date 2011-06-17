From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 17:15:24 +0900
Message-ID: <4DFB0D1C.9080804@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <4DFACAF1.3010300@hitachi.com> <20110617052230.GA741@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110617052230.GA741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

(2011/06/17 14:22), Greg KH wrote:
>>>> This will ensure that kernel output and udev input are consistent.  It
>>>> will still require that user space utilities which derive a name for a
>>>> device will need modifying to print out the preferred name.
>>>
>>> It also doesn't solve the issue of userspace wanting to use such a
>>> "preferred" name in the command line of tools, as there will not be a
>>> link back to the "kernel" name directly in /dev/.
>>
>> Right, this series just add a preferred name interface, and changes
>> a part of kernel messages.
> 
> So, just a tiny part of what you want to do in the end?

Right.

>>> So as userspace tools will still need to be fixed, I don't see how
>>> adding a kernel file for this is going to help any.  Well, a bit in that
>>> the kernel log files will look "different", but again, that really isn't
>>> a problem that userspace couldn't also solve with no kernel changes
>>> needed.
>>
>> hmm, He didnt say "this can solve all problems". I think
>> preferred name is just a starting point to solve these problems.
>> Actually, he decided to fix those user space tools to accept
>> persistent symbolic links, and to show it in outputs.
>>
>> It's not complete, but a good starting point, isn't it?
> 
> A starting point for what?  What is your "end goal" here to accomplish?

The goal is to allow users to access their devices via an uniformed
and simple persistent name. "Access" is not only read/write but also
checking the device status(e.g. procfs), finding the device from log
(dmesg) and using tools.
Of course, the last issue is only for the tools, and we should fix
individual tools instead of kernel.

> As this does not seem to me to really solve what you see as your "real"
> problem, perhaps you can explain what your next steps are going to be
> after this?

After this (kernel side change), we'd like to fix those tools to
accept preferred-name, and to show it, as Nao said;

> 1. kernel messages doesn't show persistent device names
> 2. procfs messages doesn't show persistent device names
> 3. Some commands didn't support persistent device name in arguments
> 4. Some commands message didn't show persistent device names
[...]
> Issue 3 and 4 is command releated issue. Commands have to be
> modified to use preferred name. We need to create library for
> preferred name.

Of course, in this step, we will provide a document how to setup
this feature, a udev rule(Nao sent an example rule in another mail)
and helper scripts, so that someone who are interested in the preferred
device naming can test this.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
