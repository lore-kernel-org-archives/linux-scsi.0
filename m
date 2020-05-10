Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98805C35280
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 06:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704062070B
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 06:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byOnXGnf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgEJGse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 02:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJGsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 02:48:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6229C061A0C;
        Sat,  9 May 2020 23:48:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so6189228pjb.3;
        Sat, 09 May 2020 23:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l/8M9WGtxo6PbsxhSHfbtuvDOM6UKdX+q+/zdI2w/Dw=;
        b=byOnXGnfKoI8tIQG9NZ1UOLtVgbChvyiBOYc7BuDW9t/w0KSM5B0xIDhb4Xza6PDM4
         IlY9mNb6hRgNfEFDjDlVjS/LBS8vN0ubXNz1Ag1pylQJRewpBWTNF4nc4Ju8X76jcOUq
         a8s6iPFY4Hr1TDkCqr8ugUnsIhBQbW/8QKlvkjiC/RSwS7xKd8sG47OHxeNN4AEEOP3C
         XhYrElDJYeJZjYS1GSdqha+bCIN4crpYvabg5Aia0zZOoKonwh8jEAiHN50lWA5xmQKb
         kR6Sn2ov0OlLsS4WpCaJ25Q1cItsWyzQZOSx5W22mwAUE21kf58lweCzr5Ktg+/5m2uQ
         /itA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l/8M9WGtxo6PbsxhSHfbtuvDOM6UKdX+q+/zdI2w/Dw=;
        b=XMPXrxGkR9Ir82VJYUxT8nSN9jUEPGUGhesPE0LwmObdo4a6+XWiHfro+WgnZqjiQL
         qIFA3tG81u1dVh+5r9AWdKSvaosifNstEtIE+xZL7BsB8/pfpaU0QRH7ZSPljXgsxV7X
         wi9Sh6FgCHSPSkVTdSGgkEq/tE6HdUtaYaeQh+rF3ZtY8y0FXF7a3QaD3FPjzK1xTxet
         XkaMOp9G3zSyx/pWyyWA9lCZoPHGTFkz+yrAj9cqCNMpRivOQPhCB6rxUWcqLjQ8Qs48
         PHF7mNkul4QbYmc2UjnDrYunJ/JMJabG6Zb40TchuCZRvUSp0Y7W5OiE3eYrSucDxAGH
         BBnw==
X-Gm-Message-State: AGi0PuaUbNkgdCV4LNyWX7NCGTYlhJ3YBEyPltvxVDxm4yHnXDMjKfZu
        WxzAZKiyyBRsNF5wWJCa1tDHLtk8
X-Google-Smtp-Source: APiQypJ+2JyRPcnqESYdW+4iYrPZYrPa/bZhrQndJw3KOcbNOSFFmTW93Nobsr6ie+4qZhB35QlpjQ==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr15875216pjb.146.1589093312825;
        Sat, 09 May 2020 23:48:32 -0700 (PDT)
Received: from ASMDT.1 ([114.125.231.97])
        by smtp.gmail.com with ESMTPSA id z15sm6472198pjt.20.2020.05.09.23.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 23:48:32 -0700 (PDT)
Subject: Re: USB Attached SCSI breakage due no udev involvement
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
From:   Dio Putra <dioput12@gmail.com>
Message-ID: <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
Date:   Sun, 10 May 2020 13:48:24 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200510054717.GA3365021@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 12:47 PM, Greg KH wrote:
> On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
>> Hi, it's first time for me to report user-space breakage in here, so
>> i'm begging your pardon.
>>
>> I want to report that Linux 5.4 breaking my USB mount workflow due
>> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
>> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
> 
> <snip>
> 
> Sorry, but what actually changed that you can see in the logs?
Sorry, what do you mean? The dmesg log or the kernel changelogs?

> 
> What functionality broke?  What used to work that no longer does work?
> 
Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.

Here's my personal conclusion:

[Slackware64-Current linux-5.4.39]$ sudo strace -p 2417
strace: Process 2417 attached
write(1, "KERNEL[672.150926] remove   /dev"..., 84) = 84
epoll_wait(3, [{EPOLLIN, {u32=5, u64=5}}], 4, -1) = 1
recvmsg(5, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=0x000001}, msg_namelen=128->12, msg_iov=[{iov_base="remove@/devices/pci0000:00/0000:"..., iov_len=8192}], msg_iovlen=1, msg_control=[{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, cmsg_data={pid=0, uid=0, gid=0}}], msg_controllen=32, msg_flags=0}, 0) = 269
write(1, "KERNEL[672.151622] remove   /dev"..., 122) = 122
epoll_wait(3, [{EPOLLIN, {u32=5, u64=5}}], 4, -1) = 1
recvmsg(5, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=0x000001}, msg_namelen=128->12, msg_iov=[{iov_base="remove@/devices/pci0000:00/0000:"..., iov_len=8192}], msg_iovlen=1, msg_control=[{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, cmsg_data={pid=0, uid=0, gid=0}}], msg_controllen=32, msg_flags=0}, 0) = 255
write(1, "KERNEL[672.152396] remove   /dev"..., 138) = 138
epoll_wait(3, [{EPOLLIN, {u32=5, u64=5}}], 4, -1) = 1
recvmsg(5, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=0x000001}, msg_namelen=128->12, msg_iov=[{iov_base="remove@/devices/virtual/bdi/11:0"..., iov_len=8192}], msg_iovlen=1, msg_control=[{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, cmsg_data={pid=0, uid=0, gid=0}}], msg_controllen=32, msg_flags=0}, 0) = 107
write(1, "KERNEL[672.153191] remove   /dev"..., 60) = 60
...<snip>...

"So the summary of syscall on linux-5.4.39 it's something like: write -->  epoll_wait --> recvmsg (direct call from kernel only, no udev dependencies has been called ever) --> write"

[Slackware64-14.2 linux-kernel-4.4.221] $ sudo strace -p 2102
strace: Process 2102 attached
write(1, "KERNEL[160.475104] remove   /dev"..., 84) = 84
epoll_wait(3, [{EPOLLIN, {u32=4, u64=4}}], 4, -1) = 1
recvmsg(4, {msg_name(12)={sa_family=AF_NETLINK, pid=598, groups=00000002}, msg_iov(1)=[{"libudev\0\376\355\312\376(\0\0\0(\0\0\0\375\0\0\0\5w\305\345\261\2Ge"..., 8192}], msg_controllen=32, [{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, {pid=2116, uid=0, gid=0}}], msg_flags=0}, 0) = 293
write(1, "UDEV  [160.476746] remove   /dev"..., 84) = 84
epoll_wait(3, [{EPOLLIN, {u32=5, u64=5}}], 4, -1) = 1
recvmsg(5, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000001}, msg_iov(1)=[{"remove@/devices/pci0000:00/0000:"..., 8192}], msg_controllen=32, [{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, {pid=0, uid=0, gid=0}}], msg_flags=0}, 0) = 256
write(1, "KERNEL[160.478096] remove   /dev"..., 76) = 76
epoll_wait(3, [{EPOLLIN, {u32=4, u64=4}}], 4, -1) = 1
recvmsg(4, {msg_name(12)={sa_family=AF_NETLINK, pid=598, groups=00000002}, msg_iov(1)=[{"libudev\0\376\355\312\376(\0\0\0(\0\0\0\26\2\0\0\5w\305\345'\370\365\f"..., 8192}], msg_controllen=32, [{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, {pid=2116, uid=0, gid=0}}], msg_flags=0}, 0) = 574
write(1, "UDEV  [160.495353] remove   /dev"..., 76) = 76
epoll_wait(3, [{EPOLLIN, {u32=5, u64=5}}], 4, -1) = 1
recvmsg(5, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000001}, msg_iov(1)=[{"add@/devices/pci0000:00/0000:00:"..., 8192}], msg_controllen=32, [{cmsg_len=28, cmsg_level=SOL_SOCKET, cmsg_type=SCM_CREDENTIALS, {pid=0, uid=0, gid=0}}], msg_flags=0}, 0) = 250
write(1, "KERNEL[161.109310] add      /dev"..., 76) = 76
...<snip>...

"So the summary of syscall on linux-4.4.221 it's something like: write --> epoll_wait --> recvmsg (libudev has been called) --> write (UDEV has been called) --> epoll_wait -> recvmsg (libudev has been called again)-> write"
  
> And 4.4.221 is quite different from 5.4, is that the jump that you are
> seeing breakage in, or is it in some smaller jump?
> 
Yeah, I know it's really different between linux-4.4 and linux-5.4

> thanks,
> 
> greg k-h
> 
