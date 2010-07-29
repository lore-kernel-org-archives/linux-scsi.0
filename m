From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: extfs reliability
Date: Thu, 29 Jul 2010 22:20:12 +0400
Message-ID: <4C51C65C.3080006@vlnb.net>
References: <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729083142.GA30077@lst.de> <4C517B5A.3020905@vlnb.net> <20100729142650.GA12690@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0G2SUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 14:20:11 -0400
In-Reply-To: <20100729142650.GA12690@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org

Jan Kara, on 07/29/2010 06:26 PM wrote:
>> root@ini:/mnt/dbench-mod# ^C
>> root@ini:/mnt/dbench-mod# ^C
>> root@ini:~# umount /mnt
>> Segmentation fault
>    This isn't OK of course ;)
> 
>> Kernel log:
>>
>> Jul 29 19:55:35 ini kernel: [ 3044.722313] c2c28e40: 00023740 00023741 00023742 00023743  @7..A7..B7..C7..
>> Jul 29 19:55:35 ini kernel: [ 3044.722320] c2c28e50: 00023744 00023745 00023746 00023747  D7..E7..F7..G7..
>> Jul 29 19:55:35 ini kernel: [ 3044.722327] c2c28e60: 00023748 00023749 0002374a 0002374b  H7..I7..J7..K7..
>> Jul 29 19:55:35 ini kernel: [ 3044.722334] c2c28e70: 0002372c 00000000 00000000 00000000  ,7..............
>> Jul 29 19:55:35 ini kernel: [ 3044.722341] c2c28e80: 00000000 00000000 00000000 00000002  ................
> ...
> Sadly these messages above seem to have overwritten beginning of the
> message below. Hmm, but maybe it's just a warning message about inode still
> being on orphan list because the next oops still shows untainted kernel.

You can find previous messages in the attachments I attached to the report. They are big (500K and 1M), so I compressed and attached them.
 
>> Jul 29 19:55:35 ini kernel: [ 3044.722546] Pid: 1299, comm: umount Not tainted 2.6.32-22-386 #36-Ubuntu
>> Jul 29 19:55:35 ini kernel: [ 3044.722550] Call Trace:
>> Jul 29 19:55:35 ini kernel: [ 3044.722567]  [<c0291731>] ext4_destroy_inode+0x91/0xa0
>> Jul 29 19:55:35 ini kernel: [ 3044.722577]  [<c020ecb4>] destroy_inode+0x24/0x40
>> Jul 29 19:55:35 ini kernel: [ 3044.722583]  [<c020f11e>] dispose_list+0x8e/0x100
>> Jul 29 19:55:35 ini kernel: [ 3044.722588]  [<c020f534>] invalidate_inodes+0xf4/0x120
>> Jul 29 19:55:35 ini kernel: [ 3044.722598]  [<c023b310>] ? vfs_quota_off+0x0/0x20
>> Jul 29 19:55:35 ini kernel: [ 3044.722606]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
>> Jul 29 19:55:35 ini kernel: [ 3044.722612]  [<c01fc6ca>] kill_block_super+0x2a/0x50
>> Jul 29 19:55:35 ini kernel: [ 3044.722618]  [<c01fd4e4>] deactivate_super+0x64/0x90
>> Jul 29 19:55:35 ini kernel: [ 3044.722625]  [<c021282f>] mntput_no_expire+0x8f/0xe0
>> Jul 29 19:55:35 ini kernel: [ 3044.722631]  [<c0212e47>] sys_umount+0x47/0xa0
>> Jul 29 19:55:35 ini kernel: [ 3044.722636]  [<c0212ebe>] sys_oldumount+0x1e/0x20
>> Jul 29 19:55:35 ini kernel: [ 3044.722643]  [<c01033ec>] syscall_call+0x7/0xb
>> Jul 29 19:55:35 ini kernel: [ 3044.731043] sd 6:0:0:0: [sdb] Unhandled error code
>> Jul 29 19:55:35 ini kernel: [ 3044.731049] sd 6:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
>> Jul 29 19:55:35 ini kernel: [ 3044.731056] sd 6:0:0:0: [sdb] CDB: Write(10): 2a 00 00 00 00 00 00 00 01 00
>> Jul 29 19:55:35 ini kernel: [ 3044.743469] __ratelimit: 37 callbacks suppressed
>> Jul 29 19:55:35 ini kernel: [ 3044.755695] lost page write due to I/O error on sdb
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] Modules linked in: crc32c ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi w83627hf hwmon_vid fbcon tileblit font bitblit softcursor ppdev adm1021 i2c_i801 vga16fb vgastate e7xxx_edac psmouse serio_raw parport_pc shpchp edac_core lp parport qla2xxx ohci1394 scsi_transport_fc r8169 sata_via ieee1394 mii scsi_tgt e1000 floppy
>    So here probably starts the real oops.

It isn't yet an oops, it's dump_stack() from ext4_destroy_inode() together with hex dump:

static void ext4_destroy_inode(struct inode *inode)
{
	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
		ext4_msg(inode->i_sb, KERN_ERR,
			 "Inode %lu (%p): orphan list check failed!",
			 inode->i_ino, EXT4_I(inode));
		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 16, 4,
				EXT4_I(inode), sizeof(struct ext4_inode_info),
				true);
		dump_stack();
	}
	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
}

> But sadly we are missing the
> beginning as well.

It was also in the attached file.

> Can you send me disassembly of your ext4_put_super?

In System.map-2.6.32-22-386:

c0293940 t ext4_put_super
c0293c90 t ext4_quota_write

$ objdump -d --start-address=0xc0293940 vmlinux >ext4_put_super
^C
$ cat ext4_put_super 

vmlinux:     file format elf32-i386


Disassembly of section .text:

c0293940 <.text+0x193940>:
c0293940:	55                   	push   %ebp
c0293941:	89 e5                	mov    %esp,%ebp
c0293943:	57                   	push   %edi
c0293944:	56                   	push   %esi
c0293945:	53                   	push   %ebx
c0293946:	83 ec 28             	sub    $0x28,%esp
c0293949:	e8 02 07 e7 ff       	call   0xc0104050
c029394e:	8b 98 84 01 00 00    	mov    0x184(%eax),%ebx
c0293954:	89 c6                	mov    %eax,%esi
c0293956:	8b 83 2c 02 00 00    	mov    0x22c(%ebx),%eax
c029395c:	8b 7b 38             	mov    0x38(%ebx),%edi
c029395f:	e8 ac b5 ec ff       	call   0xc015ef10
c0293964:	8b 83 2c 02 00 00    	mov    0x22c(%ebx),%eax
c029396a:	e8 41 af ec ff       	call   0xc015e8b0
c029396f:	89 f0                	mov    %esi,%eax
c0293971:	e8 5a 86 f6 ff       	call   0xc01fbfd0
c0293976:	e8 05 5a 2e 00       	call   0xc0579380
c029397b:	80 7e 11 00          	cmpb   $0x0,0x11(%esi)
c029397f:	0f 85 0b 02 00 00    	jne    0xc0293b90
c0293985:	8b 83 34 01 00 00    	mov    0x134(%ebx),%eax
c029398b:	85 c0                	test   %eax,%eax
c029398d:	74 17                	je     0xc02939a6
c029398f:	e8 ec 64 02 00       	call   0xc02b9e80
c0293994:	c7 83 34 01 00 00 00 	movl   $0x0,0x134(%ebx)
c029399b:	00 00 00 
c029399e:	85 c0                	test   %eax,%eax
c02939a0:	0f 88 ff 01 00 00    	js     0xc0293ba5
c02939a6:	89 f0                	mov    %esi,%eax
c02939a8:	e8 c3 22 01 00       	call   0xc02a5c70
c02939ad:	89 f0                	mov    %esi,%eax
c02939af:	e8 0c dc 00 00       	call   0xc02a15c0
c02939b4:	89 f0                	mov    %esi,%eax
c02939b6:	e8 c5 51 00 00       	call   0xc0298b80
c02939bb:	89 f0                	mov    %esi,%eax
c02939bd:	e8 de 45 01 00       	call   0xc02a7fa0
c02939c2:	f6 46 30 01          	testb  $0x1,0x30(%esi)
c02939c6:	0f 84 9c 01 00 00    	je     0xc0293b68
c02939cc:	8b 93 f8 00 00 00    	mov    0xf8(%ebx),%edx
c02939d2:	85 d2                	test   %edx,%edx
c02939d4:	74 11                	je     0xc02939e7
c02939d6:	8b 15 c8 8a 8a c0    	mov    0xc08a8ac8,%edx
c02939dc:	8d 86 64 01 00 00    	lea    0x164(%esi),%eax
c02939e2:	e8 59 fd fa ff       	call   0xc0243740
c02939e7:	8d bb fc 00 00 00    	lea    0xfc(%ebx),%edi
c02939ed:	89 f8                	mov    %edi,%eax
c02939ef:	e8 7c 5f 0a 00       	call   0xc0339970
c02939f4:	8b 43 14             	mov    0x14(%ebx),%eax
c02939f7:	85 c0                	test   %eax,%eax
c02939f9:	0f 84 c3 01 00 00    	je     0xc0293bc2
c02939ff:	31 d2                	xor    %edx,%edx
c0293a01:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
c0293a04:	31 c0                	xor    %eax,%eax
c0293a06:	89 75 f0             	mov    %esi,-0x10(%ebp)
c0293a09:	89 de                	mov    %ebx,%esi
c0293a0b:	89 d3                	mov    %edx,%ebx
c0293a0d:	8d 76 00             	lea    0x0(%esi),%esi
c0293a10:	8b 04 81             	mov    (%ecx,%eax,4),%eax
c0293a13:	85 c0                	test   %eax,%eax
c0293a15:	74 08                	je     0xc0293a1f
c0293a17:	e8 54 ab f8 ff       	call   0xc021e570
c0293a1c:	8b 4e 3c             	mov    0x3c(%esi),%ecx
c0293a1f:	83 c3 01             	add    $0x1,%ebx
c0293a22:	39 5e 14             	cmp    %ebx,0x14(%esi)
c0293a25:	89 d8                	mov    %ebx,%eax
c0293a27:	77 e7                	ja     0xc0293a10
c0293a29:	89 f3                	mov    %esi,%ebx
c0293a2b:	8b 75 f0             	mov    -0x10(%ebp),%esi
c0293a2e:	89 c8                	mov    %ecx,%eax
c0293a30:	e8 fb bb f5 ff       	call   0xc01ef630
c0293a35:	8b 15 2c 53 8a c0    	mov    0xc08a532c,%edx
c0293a3b:	8b 83 28 02 00 00    	mov    0x228(%ebx),%eax
c0293a41:	81 c2 00 00 80 00    	add    $0x800000,%edx
c0293a47:	39 d0                	cmp    %edx,%eax
c0293a49:	72 20                	jb     0xc0293a6b
c0293a4b:	8b 15 c0 17 75 c0    	mov    0xc07517c0,%edx
c0293a51:	81 ea 00 20 60 00    	sub    $0x602000,%edx
c0293a57:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
c0293a5d:	81 ea 00 20 00 00    	sub    $0x2000,%edx
c0293a63:	39 d0                	cmp    %edx,%eax
c0293a65:	0f 82 ed 00 00 00    	jb     0xc0293b58
c0293a6b:	e8 c0 bb f5 ff       	call   0xc01ef630
c0293a70:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax
c0293a76:	e8 c5 42 0b 00       	call   0xc0347d40
c0293a7b:	8d 83 ac 00 00 00    	lea    0xac(%ebx),%eax
c0293a81:	e8 ba 42 0b 00       	call   0xc0347d40
c0293a86:	8d 83 c4 00 00 00    	lea    0xc4(%ebx),%eax
c0293a8c:	e8 af 42 0b 00       	call   0xc0347d40
c0293a91:	8d 83 dc 00 00 00    	lea    0xdc(%ebx),%eax
c0293a97:	e8 a4 42 0b 00       	call   0xc0347d40
c0293a9c:	8b 43 34             	mov    0x34(%ebx),%eax
c0293a9f:	85 c0                	test   %eax,%eax
c0293aa1:	74 05                	je     0xc0293aa8
c0293aa3:	e8 c8 aa f8 ff       	call   0xc021e570
c0293aa8:	8b 83 78 01 00 00    	mov    0x178(%ebx),%eax
c0293aae:	e8 7d bb f5 ff       	call   0xc01ef630
c0293ab3:	8b 83 7c 01 00 00    	mov    0x17c(%ebx),%eax
c0293ab9:	e8 72 bb f5 ff       	call   0xc01ef630
c0293abe:	8d 93 38 01 00 00    	lea    0x138(%ebx),%edx
c0293ac4:	3b 93 38 01 00 00    	cmp    0x138(%ebx),%edx
c0293aca:	0f 85 fa 00 00 00    	jne    0xc0293bca
c0293ad0:	8b 86 94 00 00 00    	mov    0x94(%esi),%eax
c0293ad6:	e8 65 b4 f8 ff       	call   0xc021ef40
c0293adb:	8b 83 74 01 00 00    	mov    0x174(%ebx),%eax
c0293ae1:	85 c0                	test   %eax,%eax
c0293ae3:	74 31                	je     0xc0293b16
c0293ae5:	3b 86 94 00 00 00    	cmp    0x94(%esi),%eax
c0293aeb:	74 29                	je     0xc0293b16
c0293aed:	e8 4e 0f f9 ff       	call   0xc0224a40
c0293af2:	8b 83 74 01 00 00    	mov    0x174(%ebx),%eax
c0293af8:	e8 43 b4 f8 ff       	call   0xc021ef40
c0293afd:	8b 83 74 01 00 00    	mov    0x174(%ebx),%eax
c0293b03:	85 c0                	test   %eax,%eax
c0293b05:	74 0f                	je     0xc0293b16
c0293b07:	e8 64 d7 ff ff       	call   0xc0291270
c0293b0c:	c7 83 74 01 00 00 00 	movl   $0x0,0x174(%ebx)
c0293b13:	00 00 00 
c0293b16:	c7 86 84 01 00 00 00 	movl   $0x0,0x184(%esi)
c0293b1d:	00 00 00 
c0293b20:	e8 2b 58 2e 00       	call   0xc0579350
c0293b25:	89 f0                	mov    %esi,%eax
c0293b27:	e8 c4 84 f6 ff       	call   0xc01fbff0
c0293b2c:	89 f8                	mov    %edi,%eax
c0293b2e:	e8 7d 5d 0a 00       	call   0xc03398b0
c0293b33:	8d 83 20 01 00 00    	lea    0x120(%ebx),%eax
c0293b39:	e8 d2 3b 2e 00       	call   0xc0577710
c0293b3e:	8b 83 f4 00 00 00    	mov    0xf4(%ebx),%eax
c0293b44:	e8 e7 ba f5 ff       	call   0xc01ef630
c0293b49:	89 d8                	mov    %ebx,%eax
c0293b4b:	e8 e0 ba f5 ff       	call   0xc01ef630
c0293b50:	83 c4 28             	add    $0x28,%esp
c0293b53:	5b                   	pop    %ebx
c0293b54:	5e                   	pop    %esi
c0293b55:	5f                   	pop    %edi
c0293b56:	5d                   	pop    %ebp
c0293b57:	c3                   	ret    
c0293b58:	e8 e3 db f4 ff       	call   0xc01e1740
c0293b5d:	8d 76 00             	lea    0x0(%esi),%esi
c0293b60:	e9 0b ff ff ff       	jmp    0xc0293a70
c0293b65:	8d 76 00             	lea    0x0(%esi),%esi
c0293b68:	8b 86 84 01 00 00    	mov    0x184(%esi),%eax
c0293b6e:	ba 01 00 00 00       	mov    $0x1,%edx
c0293b73:	8b 40 38             	mov    0x38(%eax),%eax
c0293b76:	83 60 60 fb          	andl   $0xfffffffb,0x60(%eax)
c0293b7a:	0f b7 43 58          	movzwl 0x58(%ebx),%eax
c0293b7e:	66 89 47 3a          	mov    %ax,0x3a(%edi)
c0293b82:	89 f0                	mov    %esi,%eax
c0293b84:	e8 67 e5 ff ff       	call   0xc02920f0
c0293b89:	e9 3e fe ff ff       	jmp    0xc02939cc
c0293b8e:	66 90                	xchg   %ax,%ax
c0293b90:	ba 01 00 00 00       	mov    $0x1,%edx
c0293b95:	89 f0                	mov    %esi,%eax
c0293b97:	e8 54 e5 ff ff       	call   0xc02920f0
c0293b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0293ba0:	e9 e0 fd ff ff       	jmp    0xc0293985
c0293ba5:	89 34 24             	mov    %esi,(%esp)
c0293ba8:	c7 44 24 08 bf 9c 6c 	movl   $0xc06c9cbf,0x8(%esp)
c0293baf:	c0 
c0293bb0:	c7 44 24 04 64 3e 59 	movl   $0xc0593e64,0x4(%esp)
c0293bb7:	c0 
c0293bb8:	e8 d3 f1 ff ff       	call   0xc0292d90
c0293bbd:	e9 e4 fd ff ff       	jmp    0xc02939a6
c0293bc2:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
c0293bc5:	e9 64 fe ff ff       	jmp    0xc0293a2e
c0293bca:	8b 43 38             	mov    0x38(%ebx),%eax
c0293bcd:	8b 80 e8 00 00 00    	mov    0xe8(%eax),%eax
c0293bd3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0293bd6:	c7 44 24 08 be a9 6c 	movl   $0xc06ca9be,0x8(%esp)
c0293bdd:	c0 
c0293bde:	c7 44 24 04 b9 0c 6a 	movl   $0xc06a0cb9,0x4(%esp)
c0293be5:	c0 
c0293be6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0293bea:	89 34 24             	mov    %esi,(%esp)
c0293bed:	e8 be d8 ff ff       	call   0xc02914b0
c0293bf2:	c7 04 24 f6 9c 6c c0 	movl   $0xc06c9cf6,(%esp)
c0293bf9:	e8 4d 2e 2e 00       	call   0xc0576a4b
c0293bfe:	8b 83 38 01 00 00    	mov    0x138(%ebx),%eax
c0293c04:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0293c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0293c0a:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0293c0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0293c10:	8b 02                	mov    (%edx),%eax
c0293c12:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0293c16:	39 55 ec             	cmp    %edx,-0x14(%ebp)
c0293c19:	75 13                	jne    0xc0293c2e
c0293c1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0293c1e:	3b 93 38 01 00 00    	cmp    0x138(%ebx),%edx
c0293c24:	0f 84 a6 fe ff ff    	je     0xc0293ad0
c0293c2a:	0f 0b                	ud2a   
c0293c2c:	eb fe                	jmp    0xc0293c2c
c0293c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0293c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0293c34:	83 c2 20             	add    $0x20,%edx
c0293c37:	8b 4a c0             	mov    -0x40(%edx),%ecx
c0293c3a:	83 e8 68             	sub    $0x68,%eax
c0293c3d:	89 4c 24 18          	mov    %ecx,0x18(%esp)
c0293c41:	8b 88 b0 00 00 00    	mov    0xb0(%eax),%ecx
c0293c47:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0293c4b:	0f b7 88 fa 00 00 00 	movzwl 0xfa(%eax),%ecx
c0293c52:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0293c56:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0293c5a:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
c0293c60:	89 54 24 08          	mov    %edx,0x8(%esp)
c0293c64:	8b 80 2c 01 00 00    	mov    0x12c(%eax),%eax
c0293c6a:	c7 04 24 54 b0 6b c0 	movl   $0xc06bb054,(%esp)
c0293c71:	05 64 01 00 00       	add    $0x164,%eax
c0293c76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0293c7a:	e8 cc 2d 2e 00       	call   0xc0576a4b
c0293c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0293c82:	8b 12                	mov    (%edx),%edx
c0293c84:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0293c87:	eb 84                	jmp    0xc0293c0d
c0293c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

The rest snipped.
 
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] Pid: 1299, comm: umount Not tainted (2.6.32-22-386 #36-Ubuntu) X5DPA
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] EIP: 0060:[<c0293c2a>] EFLAGS: 00010206 CPU: 0
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] EIP is at ext4_put_super+0x2ea/0x350
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] EAX: c2c28ea8 EBX: c307f000 ECX: ffffff52 EDX: c307f138
>> Jul 29 19:55:36 ini kernel: [ 3044.823044] ESI: ca228a00 EDI: c307f0fc EBP: cec6ff30 ESP: cec6fefc
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  c06bb054 ca228b64 0000800b c2c28ec8 00008180 00000001 00000000 c307f138
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]<0>  c307f138 c307f138 ca228a00 c0593c80 c023b310 cec6ff48 c01fc60d ca228ac0
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]<0>  cec6ff44 cf328400 00000003 cec6ff58 c01fc6ca ca228a00 c0759d80 cec6ff6c
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c023b310>] ? vfs_quota_off+0x0/0x20
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fc60d>] ? generic_shutdown_super+0x4d/0xe0
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fc6ca>] ? kill_block_super+0x2a/0x50
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fd4e4>] ? deactivate_super+0x64/0x90
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c021282f>] ? mntput_no_expire+0x8f/0xe0
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c0212e47>] ? sys_umount+0x47/0xa0
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c0212ebe>] ? sys_oldumount+0x1e/0x20
>> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01033ec>] ? syscall_call+0x7/0xb
>> Jul 29 19:55:36 ini kernel: [ 3045.299442] ---[ end trace 426db011a0289db3 ]---
> ...
>> Another test. Everything is as before, only I did not pull the cable, but
>> deleted the corresponding LUN on the target, so all the command starting
>> from this moment failed. Then on umount system rebooted. Kernel log:
> 
>    Nasty. But the log actually contains only traces of processes in D state
> (generally waiting for a page to be unlocked). Do you have any sort of
> watchdog which might have rebooted the machine?

I didn't configured it ;). This is unmodified Ubuntu server 10.04, only with non-PAE kernel.

The reboot wasn't immediate. I even tried to check something in another ssh.

Again, you can find more logs attached to the original message.
 
>    Thanks for running the test.

Thanks for looking at the results!

Vlad
